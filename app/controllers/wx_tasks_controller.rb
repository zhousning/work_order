class WxTasksController < ApplicationController
  #skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :wxuser_exist?

   
  def index
    @tasks = @factory.tasks.all.page( params[:page]).per( Setting.systems.per_page )
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

