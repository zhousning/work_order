module StaticLib
  def get_fct_sign_logs(_start, _end, device_arr)
    device_str = device_arr.join(',')
    @sign_logs = SignLog.find_by_sql("
      select sign_date, device_id device_flag, d.id device_id, mdno, unit, d.name device_name,
        wx_users.id wx_user_id, wx_users.name wx_user_name, wx_users.phone wx_user_phone,
        workers.id worker_id, workers.name worker_name, workers.idfront idfront
      FROM (select * from sign_logs WHERE (sign_date between '" + _start.to_s + "' and '" + _end.to_s + "' and device_id in (" + device_str + ")) ) c 
      INNER JOIN workers ON c.worker_id = workers.id
      INNER JOIN wx_users ON c.wx_user_id = wx_users.id 
      RIGHT JOIN (select * from devices where id in (" + device_str + ")) d on c.device_id = d.id
    ")
    sign_logs = parse_sign_logs(@sign_logs)
    return sign_logs
  end

  def get_sign_logs(_start, _end)
    @sign_logs = SignLog.find_by_sql("
      select sign_date, device_id device_flag, devices.id device_id, mdno, unit, devices.name device_name,
        wx_users.id wx_user_id, wx_users.name wx_user_name, wx_users.phone wx_user_phone,
        workers.id worker_id, workers.name worker_name, workers.idfront idfront
      FROM (select * from sign_logs WHERE (sign_date between '" + _start.to_s + "' and '" + _end.to_s + "') ) c 
      INNER JOIN workers ON c.worker_id = workers.id
      INNER JOIN wx_users ON c.wx_user_id = wx_users.id 
      RIGHT JOIN devices on c.device_id = devices.id
    ")
    sign_logs = parse_sign_logs(@sign_logs)
    return sign_logs
  end

  def parse_sign_logs(sign_logs)
    hash = Hash.new
    sign_logs.each do |sign_log|
      sign_date = sign_log.sign_date
      device_id = sign_log.device_id.to_s
      device_flag = sign_log.device_flag
      worker_id = sign_log.worker_id.to_s
      idfront = sign_log.idfront.to_s
      worker_name = sign_log.worker_name
      wx_user_id = sign_log.wx_user_id.to_s
      wx_user_name = sign_log.wx_user_name

      hash[device_id] = {:mdno => sign_log.mdno, :unit => sign_log.unit, :device_name => sign_log.device_name} if hash[device_id].nil?

      if device_flag.nil?
        hash[device_id]['worker'] = Hash.new
        next
      end

      if hash[device_id]['worker'].nil?
        hash[device_id]['worker'] = Hash.new
      end
      if hash[device_id]['worker'][worker_id].nil?
        worker_hash = {:idfront => idfront, :name => worker_name, :date => [sign_date], :count => 1}
        hash[device_id]['worker'][worker_id] = worker_hash 
      else
        count = hash[device_id]['worker'][worker_id][:count] + 1
        if !hash[device_id]['worker'][worker_id][:date].include?(sign_date)
          hash[device_id]['worker'][worker_id][:date] << sign_date
        end
        hash[device_id]['worker'][worker_id][:count] = count 
      end

      if hash[device_id]['wx_user'].nil?
        hash[device_id]['wx_user'] = Hash.new
      end
      hash[device_id]['wx_user'][wx_user_id] = wx_user_name  + sign_log.wx_user_phone
    end
    return hash
  end

  #只查询有记录的村庄
  #str = "
  #  sign_date, device_id device_flag, devices.id device_id, mdno, unit, devices.name device_name, 
  #  wx_users.id wx_user_id, wx_users.name wx_user_name, wx_users.phone wx_user_phone,
  #  workers.id worker_id, workers.name worker_name
  #"
  #@sign_logs = SignLog.joins(:worker, 'inner join devices on sign_logs.device_id = devices.id ', 'inner join wx_users on sign_logs.wx_user_id = wx_users.id').where(:sign_date => [_start.._end]).order('mdno').select(str)
end
