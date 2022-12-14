class WxTasksController < ApplicationController
  #skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :wxuser_exist?

   
  def index
    @tasks = @factory.tasks.all.page( params[:page]).per( Setting.systems.per_page )
  end
   
  def query_info
    wxuser = WxUser.find_by(:openid => params[:id])
    obj = {}
    if wxuser.state == Setting.states.completed
      @workorder = wxuser.work_orders.find(iddecode(params[:taskid]))
      infos = [ 
        Setting.work_orders.pdt_time + ': ' + @workorder.pdt_time,
        Setting.work_orders.person + ': ' + @workorder.person,
        Setting.work_orders.phone + ': ' + @workorder.phone,
        Setting.work_orders.content + ': ' + @workorder.content,
        Setting.work_orders.address + ': ' + @workorder.address
      ] 
      img = [] 
      @workorder.enclosures.each do |enclosure|
        img << enclosure.url
      end
      @workorder.imgs.split(',').each do |image|
        img << image
      end
      obj = {
        :number => @workorder.number,
        :infos => infos,
        :imgs => img
      }
    end

    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_pend
    wxuser = WxUser.find(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      work_order_ids = OrderLog.where(:state => Setting.states.unaccept, :wx_user => wxuser).pluck(:work_order_id)
      @workorders = WorkOrder.find(work_order_ids)
      @workorders.each do |workorder|
        obj = {}
        infos = [ 
          Setting.work_orders.pdt_time + ': ' + workorder.pdt_time,
          Setting.work_orders.person + ': ' + workorder.person,
          Setting.work_orders.phone + ': ' + workorder.phone,
          Setting.work_orders.content + ': ' + workorder.content,
          Setting.work_orders.address + ': ' + workorder.address
        ] 
        obj = {
          :number => workorder.number,
          :infos => infos
        }
        arr << obj
      end
    end

    respond_to do |f|
      f.json{ render :json => arr.to_json}
    end
  end

  def query_rate
    wxuser = WxUser.find(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      order_logs = OrderLog.where(:wx_user => wxuser, :work_order_id => iddecode(params[:taskid]))
      order_logs.each do |order_log|
        arr << {:state => order_log_state(order_log.state), :user => order_log.wx_user.name + ' ' + order_log.create_at.strftime("%Y-%m-%d %H:%M")}
      end
    end

    respond_to do |f|
      f.json{ render :json => arr.to_json}
    end
  end

  def query_record
    wxuser = WxUser.find(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      order_logs = OrderLog.where(:wx_user => wxuser, :work_order_id => iddecode(params[:taskid]), :state => Setting.states.processed)
      order_logs.each do |order_log|
        img = []
        order_log.img.split(',').each do |image|
          img << image
        end
        arr << {
          :state => order_log_state(order_log.state), 
          :user => order_log.wx_user.name,
          :time => order_log.create_at.strftime("%Y-%m-%d %H:%M")},
          :content => order_log.content,
          :imgs => img
        }
      end
    end

    respond_to do |f|
      f.json{ render :json => arr.to_json}
    end
  end

  def query_all 
    wxuser = WxUser.find_by(:openid => params[:id])
    obj = []
    if wxuser.state == Setting.states.completed
      items = wxuser.devices
   
      items.each do |item|
        inspectors = SignLog.where(:sign_date => Date.today, :wx_user_id => wxuser.id, :device_id => item.id)
        
        
        #arr = []
        #arr << ispt.worker.name
        hash = Hash.new
        inspectors.each do |ispt|
          time = ispt.created_at.strftime('%H:%M')
          if hash[ispt.worker.name].nil?
            hash[ispt.worker.name] = ':' + time 
          else
            hash[ispt.worker.name] += "-" + time
          end
        end
        obj << {
          :task_id => item.id,
          :task_date => Date.today.strftime('%Y-%m-%d'),
          :desc => item.name,
          :inspectors => hash
        }
      end
    end

    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_plan
    wxuser = WxUser.find_by(:openid => params[:id])
    sign_logs = SignLog.where(:wx_user_id => wxuser.id, :sign_date => [Date.today-10..Date.today]).order('created_at DESC').limit(20)

    obj = []
    hash = Hash.new
    sign_logs.each do |item|
      device = Device.find(item.device_id) 
      
      arr = []
      inspectors.each do |ispt|
        arr << ispt.worker.name
      end
      obj << {
        :task_id => item.id,
        :task_date => Date.today.strftime('%Y-%m-%d'),
        :desc => item.name,
        :inspectors => arr
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_finish
    wxuser = WxUser.find_by(:openid => params[:id])
    #@factory = wxuser.factory

    #items = @factory.tasks.where(['state = ?', Setting.states.completed])
    items = wxuser.tasks.where(['task_date < ? ', Date.today])
   
    obj = []
    items.each do |item|
      inspectors = item.wx_users
      arr = []
      inspectors.each do |ispt|
        arr << ispt.name + ispt.phone
      end
      obj << {
        #:factory => idencode(factory.id),
        :task_id => item.id,
        :task_date => item.task_date,
        :desc => item.des,
        :inspectors => arr
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def basic_card 
    #fct_id = params[:fct_id]
    device_id = params[:device_id].to_i
    wxuser = WxUser.find_by(:openid => params[:id])
    @factory = wxuser.factory
    @device = @factory.devices.find(iddecode(device_id))

    obj = []
    #items = @factory.tasks.where(['task_date = ? and state = ?', Date.today, Setting.states.ongoing])
    items = @factory.tasks.where(['task_date = ? ', Date.today])
    items.each do |item|
      obj << {
        :task_id => idencode(item.id),
        :task_date => item.task_date,
      }
    end
    device = {:id => idencode(@device.id), :name => @device.name} 
    respond_to do |f|
      f.json{ render :json => {:device => device, :tasks => obj}.to_json}
    end
  end

  def report_create 
    name = params[:username].gsub(/\s/,'')
    idno = params[:idno].gsub(/\s/,'')
    phone = params[:phone].gsub(/\s/,'')
    gender = params[:state]
    adress = params[:question]
    imgs = params[:imgs].join(',')
    
    if @wxuser.state != Setting.states.completed
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
      return
    end

    if idno.blank? || phone.blank? || name.blank?
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    else
      worker = Worker.where(:idno => idno).first
      if !worker.nil?
        if worker.state == Setting.states.completed
          respond_to do |f|
            f.json{ render :json => {:state => 'exist'}.to_json}
          end
        else
          factory = @wxuser.factories.first.id
          if worker.update_attributes!(:factory => factory, :wx_inviter => @wxuser.id, :state => Setting.states.ongoing, :name => name, :idno => idno, :phone => phone, :gender => gender, :adress => adress, :img => imgs)
            respond_to do |f|
              f.json{ render :json => {:state => 'success'}.to_json}
            end
          else
            respond_to do |f|
              f.json{ render :json => {:state => 'error'}.to_json}
            end
          end
        end
      else
        factory = @wxuser.factories.first.id
        @worker = Worker.new(:factory => factory, :wx_inviter => @wxuser.id, :name => name, :idno => idno, :phone => phone, :gender => gender, :adress => adress, :img => imgs, :idfront => Setting.workers.worker)

        if @worker.save
          respond_to do |f|
            f.json{ render :json => {:state => 'success'}.to_json}
          end
        else
          respond_to do |f|
            f.json{ render :json => {:state => 'error'}.to_json}
          end
        end
      end
    end
  end
   
  def task_info 
    task_id = params[:task_id].to_i
    wxuser = WxUser.find_by(:openid => params[:id])
    @task = wxuser.tasks.find(task_id)

    arr = []
    @task.wx_users.each do |ispt|
      arr << ispt.name + ispt.phone
    end
    task = {:task_date => @task.task_date, :desc => @task.des, :inspectors => arr}

    reports = [] 
    inspectors = []
    @task.task_reports.order('created_at DESC').each do |rep|
      user = rep.wx_user
      inspectors << user.name + ' ' + rep.created_at.strftime('%Y-%m-%d %H:%M:%S')
      imgs = rep.img.split(',')
      img_arr = []
      imgs.each do |img|
        img_arr << Setting.systems.host + img
      end
      reports << {
        name: user.name,
        avatar: user.avatarurl,
        time: rep.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        question: rep.question,
        state: rep.state,
        imgs: img_arr 
      }
    end
   
    respond_to do |f|
      f.json{ render :json => {:task => task, :inspectors => inspectors, :reports => reports}.to_json}
    end
  end

   
  private
    def task_params
      params.require(:task).permit( :task_date, :des , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
  
end

