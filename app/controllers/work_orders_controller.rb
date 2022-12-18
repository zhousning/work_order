class WorkOrdersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource
  

  def assign
    @work_order = WorkOrder.find(iddecode(params[:id]))
    @wxuser = WxUser.find(iddecode(params[:worker]))
    if @work_order.assign(@wxuser.id)
      respond_to do |f|
        f.json{ render :json => {:state => 'success'}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    end
  end

  def index
    @factory = my_factory
    @work_order = WorkOrder.new
  end

  def new
    @factory = my_factory
    @work_order = WorkOrder.new
  end
   
  def create
    @factory = my_factory
    @work_order = WorkOrder.new(work_order_params)
    @work_order.factory = @factory
    
    if @work_order.save
      redirect_to factory_work_orders_path(idencode(@factory.id)) 
    else
      render :new
    end
  end
   
  def edit
   
    @factory = my_factory
    @work_order = @factory.work_orders.find(iddecode(params[:id]))
   
  end
   
  def finish 
    @factory = my_factory
    @work_order = @factory.work_orders.find(iddecode(params[:id]))

    if @work_order.completed
      respond_to do |f|
        f.json{ render :json => {:state => 'success'}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => 'error'}.to_json}
      end
    end
  end
   
  def update
   
    @factory = my_factory
    @work_order = @factory.work_orders.find(iddecode(params[:id]))
   
    if @work_order.update(work_order_params)
      redirect_to edit_factory_work_order_path(idencode(@factory.id), idencode(@work_order.id)) 
    else
      render :edit
    end
  end
   
  def destroy
   
    @factory = my_factory
    @work_order = @factory.work_orders.find(iddecode(params[:id]))
    wxusers = @work_order.wx_users
   
    @work_order.destroy if wxusers.blank?
    redirect_to :action => :index
  end
   
  def show
   
    @factory = my_factory
    @work_order = @factory.work_orders.find(iddecode(params[:id]))
   
  end

  def query_info 
    @factory = my_factory
    item = @factory.work_orders.find(iddecode(params[:id]))
   
    obj = {
      Setting.work_orders.title => item.title,
      Setting.work_orders.pdt_time => item.pdt_time,
      Setting.work_orders.content => item.content,
      Setting.work_orders.address => item.address,
      Setting.work_orders.urgent => item.urgent,
      Setting.work_orders.order_time => item.order_time,
      Setting.work_orders.limit_time => item.limit_time,
      Setting.work_orders.person => item.person,
      Setting.work_orders.phone => item.phone,
    }
    respond_to do |f|
      f.json{ render :json => {:obj => obj}.to_json}
    end
  end

  def complete 
    @factory = my_factory
    @work_orders = @factory.work_orders.where(:state => Setting.states.completed).order('updated_at DESC').page( params[:page]).per( Setting.systems.per_page )
  end
   
  def query_all 
    @factory = my_factory
    items = @factory.work_orders.where("state != ?", Setting.states.completed)
   
    obj = []
    items.each do |item|
      obj << {
        :id => idencode(item.id),
       
        #:title => item.title,
       
        #:pdt_time => item.pdt_time.strftime('%Y-%m-%d %H:%M'),

        :number => item.number,
       
        :content => item.content,
       
        :address => item.address,
       
        :urgent => item.urgent,
       
        :state => order_state(item.task_logs.last.state),
       
        #:order_time => item.order_time.strftime('%Y-%m-%d %H:%M'),
       
        :limit_time => item.limit_time.strftime('%Y-%m-%d %H:%M'),
       
        :person => item.person,
       
        :phone => item.phone,
       
        :img => item.img
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
   

  
    def download_attachment 
     
      @work_order = WorkOrder.where(:user => current_user, :id => iddecode(params[:id])).first
     
      @attachment_id = params[:number].to_i
      @attachment = @work_order.attachments[@attachment_id]

      if @attachment
        send_file File.join(Rails.root, "public", URI.decode(@attachment.file_url)), :type => "application/force-download", :x_sendfile=>true
      end
    end
  

  

  
  def xls_download
    send_file File.join(Rails.root, "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)

    a_str = ""
    b_str = ""
    c_str = "" 
    d_str = ""
    e_str = ""
    f_str = ""
    g_str = ""

    results["Sheet1"][1..-1].each do |items|
      items.each do |k, v|
        if !(/A/ =~ k).nil?
          a_str = v.nil? ? "" : v 
        elsif !(/B/ =~ k).nil?
          b_str = v.nil? ? "" : v 
        elsif !(/C/ =~ k).nil?
          c_str = v.nil? ? "" : v 
        elsif !(/D/ =~ k).nil?
          d_str = v.nil? ? "" : v 
        elsif !(/E/ =~ k).nil?
          e_str = v.nil? ? "" : v 
        elsif !(/F/ =~ k).nil?
          f_str = v.nil? ? "" : v 
        elsif !(/G/ =~ k).nil?
          g_str = v.nil? ? "" : v 
          break
        end
      end
    end

    redirect_to :action => :index
  end 
  

  private
    def work_order_params
      params.require(:work_order).permit( :title, :pdt_time, :content, :address, :urgent, :order_time, :limit_time, :person, :phone, :img , attachments_attributes: attachment_params , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
    def attachment_params
      [:id, :file, :_destroy]
    end
  
  
end

