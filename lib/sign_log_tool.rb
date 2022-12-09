require 'spreadsheet' 

class SignLogTool
  include StaticLib

  #总包月报表
  def exportFctPeriodRptToExcel(_start, _end, device_arr)
    Spreadsheet.client_encoding = 'UTF-8'
    filename = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    sign_log_template = File.join(Rails.root, "templates", "sign_log.xls")
    target_excel = File.join(Rails.root, "public", "excel", filename + '.xls') 

    book = Spreadsheet.open sign_log_template 

    period = book.worksheet 'period'
    period_hash = get_fct_sign_logs(_start, _end, device_arr)
    sheet_contents(period_hash, period)

    today = book.worksheet 'today'
    today_hash = get_fct_sign_logs(Date.today, Date.today, device_arr)
    sheet_contents(today_hash, today)

    book.write target_excel

    return target_excel
  end

  #水务集团月报表
  def exportPeriodRptToExcel(_start, _end)
    Spreadsheet.client_encoding = 'UTF-8'
    filename = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    sign_log_template = File.join(Rails.root, "templates", "sign_log.xls")
    target_excel = File.join(Rails.root, "public", "excel", filename + '.xls') 

    book = Spreadsheet.open sign_log_template 

    period = book.worksheet 'period'
    period_hash = get_sign_logs(_start, _end)
    sheet_contents(period_hash, period)

    today = book.worksheet 'today'
    today_hash = get_sign_logs(Date.today, Date.today)
    sheet_contents(today_hash, today)

    book.write target_excel

    return target_excel
  end

  def sheet_contents(hash, sheet)
    start = 1
    hash.each_value do |item|
      worker_list = '' 
      supervisor_list = '' 
      manager_list = '' 
      worker_count = 0
      wx_user_list = '' 
      if !item['worker'].blank?
        worker_count = item['worker'].length
        wx_user_list = item['wx_user'].values.join(',')

        item['worker'].values.each do |worker|
          if worker[:idfront] == Setting.workers.worker
            worker_list += worker[:name] + '签到' + worker[:date].count.to_s + '天，总共' + worker[:count].to_s + '次' + '; ' 
          elsif worker[:idfront] == Setting.workers.supervisor
            supervisor_list += worker[:name] + '签到' + worker[:date].count.to_s + '天，总共' + worker[:count].to_s + '次' + '; ' 
          elsif worker[:idfront] == Setting.workers.manager
            manager_list += worker[:name] + '签到' + worker[:date].count.to_s + '天，总共' + worker[:count].to_s + '次' + '; ' 
          end
        end
      end

      sheet.row(start).height = 30
      sheet.row(start).concat [start.to_s, item[:mdno], item[:unit], item[:device_name], wx_user_list, worker_count, worker_list, manager_list , supervisor_list] 
      start += 1
    end
  end


end
