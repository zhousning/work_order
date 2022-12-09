class OrderLogsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @order_log = OrderLog.new
   
    #@order_logs = current_user.order_logs.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = OrderLog.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :feedback => item.feedback,
       
        :content => item.content,
       
        :longitude => item.longitude,
       
        :latitude => item.latitude,
       
        :upman => item.upman,
       
        :nextman => item.nextman,
       
        :start_time => item.start_time,
       
        :end_time => item.end_time,
       
        :state => item.state,
       
        :img => item.img,
       
        :address => item.address,
       
        :item => item.item
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @order_log = OrderLog.where(:user => current_user, :id => iddecode(params[:id])).first
   
  end
   

   
  def new
    @order_log = OrderLog.new
    
  end
   

   
  def create
    @order_log = OrderLog.new(order_log_params)
     
    @order_log.user = current_user
     
    if @order_log.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @order_log = OrderLog.where(:user => current_user, :id => iddecode(params[:id])).first
   
  end
   

   
  def update
   
    @order_log = OrderLog.where(:user => current_user, :id => iddecode(params[:id])).first
   
    if @order_log.update(order_log_params)
      redirect_to order_log_path(idencode(@order_log.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @order_log = OrderLog.where(:user => current_user, :id => iddecode(params[:id])).first
   
    @order_log.destroy
    redirect_to :action => :index
  end
   

  
    def download_attachment 
     
      @order_log = OrderLog.where(:user => current_user, :id => iddecode(params[:id])).first
     
      @attachment_id = params[:number].to_i
      @attachment = @order_log.attachments[@attachment_id]

      if @attachment
        send_file File.join(Rails.root, "public", URI.decode(@attachment.file_url)), :type => "application/force-download", :x_sendfile=>true
      end
    end
  

  

  
  
  

  private
    def order_log_params
      params.require(:order_log).permit( :feedback, :content, :longitude, :latitude, :upman, :nextman, :start_time, :end_time, :state, :img, :address, :item , attachments_attributes: attachment_params , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
    def attachment_params
      [:id, :file, :_destroy]
    end
  
  
end

