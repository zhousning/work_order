class SignLogsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @factory = current_user.factories.first
    gon.fct = idencode(@factory.id)
  end

  def query_device
    @factory = my_factory 
    @devices = @factory.devices
    result = []
    @devices.each do |device|
      result << {
        id: idencode(device.id),
        text: device.mdno + ' - ' + device.unit + ' - ' + device.name
      }
    end
    obj = {
      "results": result
    }
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
   
  def query_list
    _start = params[:start].gsub(/\s/, '')
    _end = params[:end].gsub(/\s/, '')
    fct = params[:fct].gsub(/\s/, '')

    items = SignLog.where(:sign_date => [_start.._end], :device_id => iddecode(fct)) 
   
    obj = []
    items.each_with_index do |item, index|
      wxuser = WxUser.where(:id => item.wx_user_id).first
      obj << {
        #:factory => idencode(factory.id),
        #:id => idencode(item.id),
        :id => index + 1, 

        :name => item.worker.name,

        :sign_date => item.created_at.strftime('%Y-%m-%d %H:%M:%S'),
       
        :wx_user_id => wxuser.nil? ? '-' : wxuser.name,
       
        :device_id => Device.find(item.device_id).name,

        :position => item.longitude + ', ' + item.latitude,

        :avatar => "<img class='h-100px' src='#{item.avatar_url}' />"
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

end

#def query_all 
#  items = SignLog.all
# 
#  obj = []
#  items.each do |item|
#    obj << {
#      #:factory => idencode(factory.id),
#      :id => idencode(item.id),
#     
#      :sign_date => item.sign_date,
#     
#      :wx_user_id => item.wx_user_id,
#     
#      :device_id => item.device_id
#    
#    }
#  end
#  respond_to do |f|
#    f.json{ render :json => obj.to_json}
#  end
#end

#def show
# 
#  @sign_log = SignLog.find(iddecode(params[:id]))
# 
#end
# 

# 
#def new
#  @sign_log = SignLog.new
#  
#end
# 

# 
#def create
#  @sign_log = SignLog.new(sign_log_params)
#   
#  if @sign_log.save
#    redirect_to :action => :index
#  else
#    render :new
#  end
#end
# 

# 
#def edit
# 
#  @sign_log = SignLog.find(iddecode(params[:id]))
# 
#end
# 

# 
#def update
# 
#  @sign_log = SignLog.find(iddecode(params[:id]))
# 
#  if @sign_log.update(sign_log_params)
#    redirect_to sign_log_path(idencode(@sign_log.id)) 
#  else
#    render :edit
#  end
#end
# 

# 
#def destroy
# 
#  @sign_log = SignLog.find(iddecode(params[:id]))
# 
#  @sign_log.destroy
#  redirect_to :action => :index
#end
 

#private
#  def sign_log_params
#    params.require(:sign_log).permit( :sign_date, :wx_user_id, :device_id , :avatar)
#  end
