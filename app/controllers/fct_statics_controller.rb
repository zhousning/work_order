class FctStaticsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource
  
  include StaticLib

  def index
    @factory = my_factory
    gon.fct = idencode(@factory.id)
  end
  
  def query_device
    @factory = my_factory
    @devices = @factory.devices.select('mdno').uniq
    result = []
    @devices.each do |device|
      result << {
        id: device.mdno,
        text: device.mdno
      }
    end
    obj = {
      "results": result
    }
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
   
  def query_by_area
    _start = params[:start].gsub(/\s/, '')
    fct = params[:fct].gsub(/\s/, '')

    select_str = "distinct worker_id, sign_date, unit, name"
    sign_logs = SignLog.joins('LEFT JOIN devices ON sign_logs.device_id = devices.id').where(['devices.mdno = ? and sign_date = ?', fct, _start]).select(select_str)

    hash = Hash.new
    sign_logs.each do |sign_log|
      hash[sign_log.unit] = Hash.new if hash[sign_log.unit].nil?
      if hash[sign_log.unit][sign_log.name].nil?
        hash[sign_log.unit][sign_log.name] = 1 
      else
        hash[sign_log.unit][sign_log.name] += 1 
      end
    end

    respond_to do |f|
      f.json{ render :json => hash.to_json}
    end
  end

  def log_detail 
    @factory = my_factory
    device_arr = @factory.devices.pluck(:id)
    _start = params[:start].gsub(/\s/, '')
    _end = params[:end].gsub(/\s/, '')

    hash = get_fct_sign_logs(_start, _end, device_arr)
   
    obj = []
    start = 1
    hash.each_value do |item|
      worker_list = '' 
      worker_count = 0
      wx_user_list = '' 
      if !item['worker'].blank?
        worker_count = item['worker'].length
        wx_user_list = item['wx_user'].values.join(',')

        item['worker'].values.each do |worker|
          worker_list += worker[:name] + worker[:date].count.to_s + '天' + worker[:count].to_s + '次' + ', ' 
        end
      end

      obj << {
        :id => start.to_s, 

        :mdno => item[:mdno],

        :unit => item[:unit],

        :name => item[:device_name],
       
        :wx_user_id => wx_user_list,

        :count => worker_count,

        :workers => worker_list
       
      }
      start += 1
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def xls_download
    @factory = my_factory
    device_arr = @factory.devices.pluck(:id)
    _start = params[:start].gsub(/\s/, '')
    _end = params[:end].gsub(/\s/, '')

    excel_tool = SignLogTool.new
    target_excel = excel_tool.exportFctPeriodRptToExcel(_start, _end, device_arr)
    send_file target_excel, :filename => _start + '-' + _end + "签到记录.xls", :type => "application/force-download", :x_sendfile=>true
  end
end
