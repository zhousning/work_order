class WxTasksController < ApplicationController
  #skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :wxuser_exist?
   
  def index
    @tasks = @factory.tasks.all.page( params[:page]).per( Setting.systems.per_page )
  end

  def task_member
    wxuser = WxUser.find_by(:openid => params[:id])
    factory = wxuser.factories.first
    if wxuser.state == Setting.states.completed
      @wxusers = []
      wxuser_arr = []
      fct_recurrence(factory, @wxusers)
      @wxusers = @wxusers.flatten
      @workorder = wxuser.work_orders.find(params[:taskid])

      @wxusers.each do |wuser|
        @order_logs = OrderLog.where(:wx_user => wuser, :work_order => @workorder)
        wxuser_arr << {:dept => wuser.id.to_s, :name => wuser.factories.first.name + '-' + wuser.name} if @order_logs.blank?
      end
      respond_to do |f|
        f.json{ render :json => {:data => wxuser_arr}.to_json}
      end
    end
  end

  def task_transfer
    wxuser = WxUser.find_by(:openid => params[:id])
    wxusers = WxUser.find(params[:sites])
    if wxuser.state == Setting.states.completed
      @workorder = wxuser.work_orders.find(params[:taskid])
      wxusers.each do |wxu|
        @order_logs = OrderLog.where(:wx_user => wxu, :work_order => @workorder)
        @workorder.transfer(wxu.id) if @order_logs.blank?
      end
      respond_to do |f|
        f.json{ render :json => {:state => 'success'}.to_json}
      end
    end
  end

  def task_processed
    wxuser = WxUser.find_by(:openid => params[:id])
    if wxuser.state == Setting.states.completed
      @workorder = wxuser.work_orders.find(params[:taskid])
      @order_log = OrderLog.where(:state => Setting.states.accept, :wx_user => wxuser, :work_order => @workorder).last
      img = params[:imgs].nil? ? '' : params[:imgs].join(',')
      if @order_log 
        @order_log.update_attributes!(:feedback => params[:feedback], :content => params[:content], :img => img, :state => Setting.states.processed)
        if @workorder.processed(wxuser.id)
          respond_to do |f|
            f.json{ render :json => {:state => 'success'}.to_json}
          end
        else
          respond_to do |f|
            f.json{ render :json => {:state => 'error'}.to_json}
          end
        end
      else
        order_log = OrderLog.new(:state => Setting.states.processed, :wx_user => wxuser, :work_order => @workorder, :feedback => params[:feedback], :content => params[:content], :img => img)
        if order_log.save && @workorder.processed(wxuser.id)
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


  def accept_task 
    wxuser = WxUser.find_by(:openid => params[:id])
    if wxuser.state == Setting.states.completed
      @workorder = wxuser.work_orders.find(params[:taskid])
      @order_log = OrderLog.where(:wx_user => wxuser, :work_order => @workorder).last
      @order_log.accept
      @workorder.processing(wxuser.id)
      respond_to do |f|
        f.json{ render :json => {:state => 'success'}.to_json}
      end
    end

  end

   
  def query_info
    wxuser = WxUser.find_by(:openid => params[:id])
    obj = {}
    if wxuser.state == Setting.states.completed
      @workorder = wxuser.work_orders.find(params[:taskid])
      infos = [ 
        Setting.work_orders.pdt_time + ': ' + @workorder.created_at.strftime("%Y-%m-%d %H:%M"),
        Setting.work_orders.limit_time + ': ' +  @workorder.limit_time.strftime('%Y-%m-%d %H:%M'),
        Setting.work_orders.person + ': ' + @workorder.person,
        Setting.work_orders.phone + ': ' + @workorder.phone,
        Setting.work_orders.address + ': ' + @workorder.address,
        Setting.work_orders.content + ': ' + @workorder.content
      ] 
      img = [] 
      @workorder.enclosures.each do |enclosure|
        img << enclosure.file_url
      end
      if @workorder.img
        @workorder.img.split(',').each do |image|
          img << image
        end
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
    wxuser = WxUser.find_by(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      work_order_ids = OrderLog.where(:state => [Setting.states.unaccept, Setting.states.accept, Setting.states.processed],:wx_user => wxuser).pluck(:work_order_id)
      @workorders = WorkOrder.find(work_order_ids)
      @workorders.each do |workorder|
        next if workorder.state == Setting.states.completed
        obj = {}
        order_log = OrderLog.where(:state => [Setting.states.unaccept, Setting.states.accept, Setting.states.processed], :work_order => workorder, :wx_user => wxuser).last
        infos = [ 
          Setting.work_orders.pdt_time + ': ' + workorder.created_at.strftime("%Y-%m-%d %H:%M"),
          Setting.work_orders.person + ': ' + workorder.person,
          Setting.work_orders.phone + ': ' + workorder.phone,
          Setting.work_orders.content + ': ' + workorder.content,
          Setting.work_orders.address + ': ' + workorder.address
        ] 
        obj = {
          :id => workorder.id,
          :number => workorder.number,
          :infos => infos,
          :task_finish => order_log.state != Setting.states.unaccept  ? true : false
        }
        arr << obj
      end
    end

    respond_to do |f|
      f.json{ render :json => arr.to_json}
    end
  end

  def query_process
    wxuser = WxUser.find_by(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      work_order_ids = OrderLog.where(:state => Setting.states.accept, :wx_user => wxuser).pluck(:work_order_id)
      @workorders = WorkOrder.find(work_order_ids)
      @workorders.each do |workorder|
        obj = {}
        infos = [ 
          Setting.work_orders.pdt_time + ': ' + workorder.created_at.strftime("%Y-%m-%d %H:%M"),
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
    wxuser = WxUser.find_by(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      @workorder = WorkOrder.find(params[:taskid])
      task_logs = @workorder.task_logs.order('created_at DESC')
      task_logs.each do |task_log|
        wxuserid = task_log.wx_user_id
        name = wxuserid ? WxUser.find(wxuserid).name : ''
        arr << {:state => order_state(task_log.state), :color => "order-" + task_log.state, :user => name + ' ' + task_log.created_at.strftime("%Y-%m-%d %H:%M")}
      end
    end

    respond_to do |f|
      f.json{ render :json => arr.to_json}
    end
  end

  def query_record
    wxuser = WxUser.find_by(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      order_logs = OrderLog.where(:work_order_id => params[:taskid], :state => Setting.states.processed).order('created_at DESC')
      order_logs.each do |order_log|
        img = []
        if order_log.img
          order_log.img.split(',').each do |image|
            img << Setting.systems.host + image
          end
        end
        arr << {
          :state => order_log_state(order_log.state), 
          :user => order_log.wx_user.name,
          :time => order_log.created_at.strftime("%Y-%m-%d %H:%M"),
          :content => order_log.content,
          :feedback => order_log.feedback,
          :imgs => img
        }
      end
    end

    respond_to do |f|
      f.json{ render :json => arr.to_json}
    end
  end


  def query_finish
    wxuser = WxUser.find_by(:openid => params[:id])
    arr = []
    if wxuser.state == Setting.states.completed
      @workorders = wxuser.work_orders.where(:state => Setting.states.completed).uniq.order('updated_at DESC').limit(10)
      @workorders.each do |workorder|
        infos = [ 
          Setting.work_orders.pdt_time + ': ' + workorder.created_at.strftime("%Y-%m-%d %H:%M"),
          Setting.work_orders.person + ': ' + workorder.person,
          Setting.work_orders.phone + ': ' + workorder.phone,
          Setting.work_orders.content + ': ' + workorder.content,
          Setting.work_orders.address + ': ' + workorder.address
        ] 
        obj = {
          :id => workorder.id,
          :number => workorder.number,
          :infos => infos,
        }
        arr << obj
      end
    end

    respond_to do |f|
      f.json{ render :json => arr.to_json}
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
  
    def fct_recurrence(factory, inspectors)
      wxusers = factory.wx_users.where(:state => Setting.states.completed)
      inspectors << wxusers unless wxusers.blank?
      
      unless factory.children.blank?
        factory.children.each do |fct|
          fct_recurrence(fct, inspectors)
        end
      end
    end

  
  
end

