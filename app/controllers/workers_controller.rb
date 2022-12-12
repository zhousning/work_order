class WorkersController < ApplicationController
  include BaiduFace
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

  def unvalidate
    @factory = my_factory
    gon.fct = idencode(@factory.id)
  end

  def query_unvalidate
    @factory = my_factory
    @workers = Worker.where(['factory = ? and state != ?', @factory.id, Setting.states.completed]).order('created_at DESC')
    obj = []
    @workers.each do |item|
      button = "<button class = 'button button-inverse button-small mr-1 log-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>签到记录</button>"
      button += "<button class = 'button button-action button-small mr-1 worker-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>证件照</button>"
      if item.state != Setting.states.processing
        button += "<button class = 'button button-primary button-small mr-1 receive-worker-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>通过</button><button class = 'button button-caution button-small mr-1 reject-worker-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>拒绝</button>"
      end
      wxuser = WxUser.where(:id => item.wx_inviter).first
      obj << {
        :id => idencode(item.id),
        :idno => item.idno,
        :wxuser => wxuser.nil? ? '-' : wxuser.name,
        :name => item.name,
        :phone => item.phone,
        :gender => user_gender(item.gender),
        :adress => item.adress,
        :state => worker_state(item.state),
        :desc => item.desc,
        :search => button,
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_all
    @factory = my_factory
    @workers = Worker.where(:factory => @factory.id, :state => Setting.states.completed).order('created_at DESC')
    obj = []
    @workers.each do |item|
      button = "<button class = 'button button-inverse button-small mr-1 log-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>签到记录</button><button class = 'button button-action button-small mr-1 worker-show-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>证件照</button>"
      button += "<a href= '/factories/" + idencode(@factory.id).to_s + "/workers/" + idencode(item.id).to_s + "/edit' class = 'button button-royal button-small mr-1 '>编辑</a>"
      wxuser = WxUser.where(:id => item.wx_inviter).first
      obj << {
        :id => idencode(item.id),
        :idno => item.idno,
        :wxuser => wxuser.nil? ? '-' : wxuser.name,
        :name => item.name,
        :phone => item.phone,
        :gender => user_gender(item.gender),
        :adress => item.adress,
        :state => worker_state(item.state),
        :info => item.info,
        :desc => item.desc,
        :search => button,
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def index
    @factory = my_factory
    gon.fct = idencode(@factory.id)
    #@workers = Worker.where(:factory => @factory.id).order('created_at DESC').page( params[:page]).per( Setting.systems.per_page )
    #@workers = Worker.where(:factory => @factory.id).order('created_at DESC')
  end

  def edit
    @factory = my_factory
    @worker = Worker.where(:factory => @factory.id, :id => iddecode(params[:id])).first
  end
   
  
   
  def update
    @factory = my_factory
    @worker = Worker.where(:factory => @factory.id, :id => iddecode(params[:id])).first
    if @worker.update(worker_params)
      redirect_to edit_factory_worker_path(idencode(@factory.id), idencode(@worker.id)) 
    else
      render :edit
    end
  end
   
  def receive 
    @factory = my_factory
    @worker = Worker.where(:factory => @factory.id, :id => iddecode(params[:id])).first
    if @worker.state != Setting.states.completed && @worker.state != Setting.states.processing
      @worker.processing
      BaiduFaceWorker.perform_async(@worker.id)
      respond_to do |f|
        f.json{ render :json => {:state => '0'}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => '1'}.to_json}
      end
    end
  end

  def reject 
    @factory = my_factory
    @worker = Worker.where(:factory => @factory.id, :id => iddecode(params[:id])).first
    if @worker.state != Setting.states.completed && @worker.state != Setting.states.processing
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
    else
      respond_to do |f|
        f.json{ render :json => {:state => '1'}.to_json}
      end
    end
  end

  def query_info 
    @factory = my_factory
    @worker = Worker.where(:factory => @factory.id, :id => iddecode(params[:id])).first
   
    info = [@worker.name, @worker.idno, @worker.phone]
    imgs = []
    @worker.img.split(',').each do |item|
      imgs << item 
    end
    respond_to do |f|
      f.json{ render :json => {:info => info, :img => imgs}.to_json}
    end
  end
   
  def destroy
    @factory = my_factory
    @worker = Worker.where(:factory => @factory.id, :id => iddecode(params[:id])).first
    if @worker.state != Setting.states.completed
      body = delete_user(@worker.idno)
      if body['error_code'] == 0
        @worker.destroy
      end
    end
    redirect_to :action => :index
  end
   
  def signlogs
    @factory = my_factory
    @worker = Worker.where(:factory => @factory.id, :id => iddecode(params[:id])).first
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
  
  private
    def worker_params
      #params.require(:worker).permit( :name, :idno, :phone, :gender, :state, :adress, :desc , :avatar , :idfront , :idback)
      params.require(:worker).permit(:name, :phone, :gender, :adress, :info)
    end
  
  
  
end

#def new
#  @worker = Worker.new
#  
#end
# 

#def show
# 
#  @worker = Worker.find(iddecode(params[:id]))
# 
#end
 
# 
#def create
#  @worker = Worker.new(worker_params)
#  face_worker = BaiDuFace.new
#   
#  if @worker.save
#    unless @worker.avatar.file.nil?
#      image = File.join(Rails.root, 'public', @worker.avatar_url)
#      image_base64 = Base64.encode64(File.read(image)).gsub(/\s/, '')
#      @worker.update_attributes!(:avatar_base => image_base64)

#      face_worker.add_face_entity(@worker.id)
#    end

#    redirect_to :action => :index
#  else
#    render :new
#  end
#end
# 

# 
 

 




