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
    @devices = []
    fct_recurrence(@factory, @devices)
    @devices = @devices.flatten

    result = []
    @devices.each do |device|
      result << {
        id: idencode(device.id),
        text: device.name
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
    _start = Date.parse(_start)
    _end = Date.parse(_end) + 1

    items = WorkOrder.where(:created_at => [_start.._end], :factory_id => iddecode(fct)) 
   
    obj = []
    items.each_with_index do |item, index|
      obj << {
        :id => idencode(item.id),
        :ctg => item.workorder_ctg.name,
        :number => item.number,
        :content => item.content[0..20] + '...',
        :address => item.address,
        :state => order_state(item.task_logs.last.state),
        :limit_time => item.limit_time.strftime('%Y-%m-%d %H:%M'),
        :pdt_time => item.created_at.strftime('%Y-%m-%d %H:%M'),
        :person => item.person,
        :phone => item.phone,
        :reminder => item.reminder ? '是' : '否',
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  private
    def fct_recurrence(factory, inspectors)
      inspectors << factory
      
      unless factory.children.blank?
        factory.children.each do |fct|
          fct_recurrence(fct, inspectors)
        end
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
