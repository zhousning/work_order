
class GrpWorkersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:send_msg]

  def index
  end

  def supervisor 
  end

  def destroy_worker
    if current_user.has_role?(Setting.roles.role_grp)
      @worker = Worker.find(iddecode(params[:id]))
      if @worker.state != Setting.states.deleting
        @worker.deleting
        WorkerDestroy.perform_async(@worker.id)
        respond_to do |f|
          f.json{ render :json => {:state => '0'}.to_json}
        end
      else
        respond_to do |f|
          f.json{ render :json => {:state => '1'}.to_json}
        end
      end
    end
  end

  def query_all 
    obj = []
    if current_user.has_role?(Setting.roles.role_cpy)
      @factory = my_cpy_factory
      @workers = Worker.where(:factory => @factory.id, :idfront => Setting.workers.worker).order('created_at DESC')
      @workers.each do |item|
        button = "<button class = 'button button-royal button-small mr-1 log-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>签到记录</button><button class = 'button button-primary button-small mr-1 worker-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>证件照</button>"
        obj << {
          :id => idencode(item.id),
          :idno => item.idno,
          :name => item.name,
          :phone => item.phone,
          :gender => user_gender(item.gender),
          :adress => item.adress,
          :state => worker_state(item.state),
          :desc => item.desc,
          :info => item.info,
          :search => button,
          :fct => Factory.find(item.factory).name
        }
      end
    else
      @workers = Worker.where(:idfront => Setting.workers.worker).order('created_at DESC').all
      @workers.each do |item|
        button = "<button class = 'button button-royal button-small mr-1 log-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>签到记录</button><button class = 'button button-primary button-small mr-1 worker-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>证件照</button><button class='button button-caution button-small mr-2 worker-delete-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "' data-confirm='确定删除吗?'>删除</button><button class = 'button button-action button-small mr-1 send-msg-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>发送消息</button>"
        obj << {
          :id => idencode(item.id),
          :idno => item.idno,
          :name => item.name,
          :phone => item.phone,
          :gender => user_gender(item.gender),
          :adress => item.adress,
          :state => worker_state(item.state),
          :desc => item.desc,
          :info => item.info,
          :search => button,
          :fct => Factory.find(item.factory).name
        }
      end
    end
   
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_supervisor
    obj = []
    if current_user.has_role?(Setting.roles.role_cpy)
      @factory = my_cpy_factory
      @workers = Worker.where(['avatar = ? and idfront in (?)', @factory.area, [Setting.workers.supervisor, Setting.workers.manager]]).order('created_at DESC')
      @workers.each do |item|
        button = "<button class = 'button button-royal button-small mr-1 log-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>签到记录</button><button class = 'button button-primary button-small mr-1 worker-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>证件照</button>"
        ctg = ''
        if item.idfront == Setting.workers.supervisor
          ctg = Setting.workers.supervisor_title
        elsif item.idfront == Setting.workers.manager
          ctg = Setting.workers.manager_title
        end
        obj << {
          :id => idencode(item.id),
          :idno => item.idno,
          :name => item.name,
          :phone => item.phone,
          :gender => user_gender(item.gender),
          :adress => item.adress,
          :state => worker_state(item.state),
          :desc => item.desc,
          :search => button,
          :info => item.info,
          :ctg => ctg,
          :avatar => item.avatar,
          :fct => item.idback 
        }
      end
    else
      @workers = Worker.where(['idfront in (?)', [Setting.workers.supervisor, Setting.workers.manager]]).order('created_at DESC').all
      @workers.each do |item|
        button = "<button class = 'button button-royal button-small mr-1 log-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>签到记录</button><button class = 'button button-primary button-small mr-1 worker-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>证件照</button><button class='button button-caution button-small mr-2 worker-delete-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "' data-confirm='确定删除吗?'>删除</button>"
        ctg = ''
        if item.idfront == Setting.workers.supervisor
          ctg = Setting.workers.supervisor_title
        elsif item.idfront == Setting.workers.manager
          ctg = Setting.workers.manager_title
        end
        obj << {
          :id => idencode(item.id),
          :idno => item.idno,
          :name => item.name,
          :phone => item.phone,
          :gender => user_gender(item.gender),
          :adress => item.adress,
          :state => worker_state(item.state),
          :desc => item.desc,
          :info => item.info,
          :search => button,
          :ctg => ctg,
          :avatar => item.avatar,
          :fct => item.idback 
        }
      end
    end
   
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
   
  def query_info 
    @worker = Worker.find(iddecode(params[:id]))
   
    info = [@worker.name, @worker.idno, @worker.phone]
    imgs = []
    @worker.img.split(',').each do |item|
      imgs << item 
    end
    respond_to do |f|
      f.json{ render :json => {:info => info, :img => imgs}.to_json}
    end
  end
   
   
  def signlogs
    @worker = Worker.find(iddecode(params[:id]))
    @sign_logs = @worker.sign_logs.order('created_at DESC') 
    obj = []
    @sign_logs.each do |item|
      wxuser = WxUser.where(:id => item.wx_user_id).first
      obj << {
        :time => item.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        :fzr => wxuser.nil? ? '-' : wxuser.name,
        :zd => Device.find(item.device_id).name,
        :jwd => item.longitude + ', ' + item.latitude,
        :img => item.avatar_url
      }
    end
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def xls_download
    send_file File.join(Rails.root, "templates", "监理总包模板.xlsx"), :filename => "监理总包模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  def parse_excel
    idfront = params['fct']
    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)

    name = ""
    idno = ""
    phone = "" 
    idback = ""
    avatar = ""

    results["Sheet1"][1..-1].each do |items|
      items.each do |k, v|
        if !(/A/ =~ k).nil?
          name = v.nil? ? "" : v.to_s.strip  
        elsif !(/B/ =~ k).nil?
          idno = v.nil? ? "" : v.to_s.strip 
        elsif !(/C/ =~ k).nil?
          phone = v.nil? ? "" : v.to_s.strip  
        elsif !(/D/ =~ k).nil?
          idback = v.nil? ? "" : v.to_s.strip  
        elsif !(/E/ =~ k).nil?
          avatar = v.nil? ? "" : v.to_s.strip  
        end
      end
      puts '............'
      puts avatar
      puts '............'

      @worker = Worker.find_by_idno(idno)
      if @worker 
        @worker.update_attributes(:idfront => idfront, :name => name, :phone => phone, :idback => idback, :avatar => avatar)
      else
        Worker.create(:idfront => idfront, :name => name, :idno => idno, :phone => phone, :idback => idback, :avatar => avatar)
      end
    end

    redirect_to supervisor_grp_workers_path 
  end 
end

