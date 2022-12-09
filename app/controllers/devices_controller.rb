class DevicesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource
   
  def index
    @factory = my_factory
  end

  def query_all 
    @factory = my_factory
    items = @factory.devices
   
    obj = []
    items.each do |item|
      obj << {
        :factory => idencode(@factory.id),
        :id => idencode(item.id),
        :idno => item.idno,
        :name => item.name,
        :mdno => item.mdno,
        :unit => item.unit,
        :state => item.state,
        :pos => item.pos,
        :supplier => item.supplier,
        :pos_no => item.pos_no
      }
    end
    obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
   
  #def new
  #  @factory = my_factory
  #  @device = Device.new
  #end
  # 
  #def create
  #  @factory = my_factory
  #  @device = Device.new(device_params)
  #  @device.factory = @factory
  #  
  #  if @device.save
  #    redirect_to edit_factory_device_path(idencode(@factory.id), idencode(@device.id)) 
  #  else
  #    render :new
  #  end
  #end
  # 
  #def edit
  # 
  #  @factory = my_factory
  #  @device = @factory.devices.find(iddecode(params[:id]))
  # 
  #end
  # 
  #def update
  # 
  #  @factory = my_factory
  #  @device = @factory.devices.find(iddecode(params[:id]))
  # 
  #  if @device.update(device_params)
  #    redirect_to edit_factory_device_path(idencode(@factory.id), idencode(@device.id)) 
  #  else
  #    render :edit
  #  end
  #end
  # 
  #def destroy
  # 
  #  @factory = my_factory
  #  @device = @factory.devices.find(iddecode(params[:id]))
  #  wxusers = @device.wx_users
  # 
  #  @device.destroy if wxusers.blank?
  #  redirect_to :action => :index
  #end
  # 
  #def xls_download
  #  send_file File.join(Rails.root, "templates", "站点模板.xlsx"), :filename => "站点模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  #end
  #
  #def parse_excel
  #  @factory = my_factory
  #  excel = params["excel_file"]
  #  tool = ExcelTool.new
  #  results = tool.parseExcel(excel.path)

  #  idno = ""
  #  name = ""
  #  mdno = "" 
  #  unit = ""
  #  life = ""
  #  state = ""
  #  desc = ""
  #  supplier = ""
  #  mfcture = ""
  #  out_date = ""
  #  pos = ""
  #  pos_no = ""
  #  mount_date = ""

  #  results["Sheet1"][1..-1].each do |items|
  #    items.each do |k, v|
  #      if !(/A/ =~ k).nil?
  #        idno = v.nil? ? "" : v.to_s.strip 
  #      elsif !(/B/ =~ k).nil?
  #        name = v.nil? ? "" : v.to_s.strip  
  #      elsif !(/C/ =~ k).nil?
  #        mdno = v.nil? ? "" : v.to_s.strip  
  #      elsif !(/D/ =~ k).nil?
  #        unit = v.nil? ? "" : v.to_s.strip  
  #      elsif !(/E/ =~ k).nil?
  #        supplier = v.nil? ? "" : v.to_s.strip  
  #      elsif !(/F/ =~ k).nil?
  #        pos = v.nil? ? "" : v.to_s.strip  
  #      elsif !(/G/ =~ k).nil?
  #        pos_no = v.nil? ? "" : v.to_s.strip  
  #      elsif !(/H/ =~ k).nil?
  #        desc = v.nil? ? "" : v.to_s.strip  
  #      elsif !(/I/ =~ k).nil?
  #        state = v.nil? ? "施工中" : v.to_s.strip
  #      end
  #    end

  #    #device = @factory.devices.where(:idno => idno).first
  #    device = @factory.devices.where(:mdno => mdno, :unit => unit, :supplier => supplier).first
  #    if device
  #      next 
  #    else
  #      @device = Device.new(:idno => idno, :name => name, :mdno => mdno, :unit => unit, :supplier => supplier, :pos => pos, :pos_no => pos_no, :desc  => desc, :state => state, :factory => @factory)

  #      @device.save
  #    end
  #  end

  #  redirect_to :action => :index
  #end 

  private
    def device_params
      params.require(:device).permit( :idno, :name, :mdno, :unit, :out_date, :mount_date, :supplier, :mfcture, :pos, :pos_no, :life, :desc , :avatar, :state)
    end
  
end

#def show
# 
#  @factory = my_factory
#  @device = @factory.devices.find(iddecode(params[:id]))
# 
#end
# 
#def info 
# 
#  @factory = Factory.find(iddecode(params[:factory_id]))
#  @device = @factory.devices.find(iddecode(params[:id]))
#  render :layout => "application_no_header"
#end

#def uphold 
# 
#  @factory = my_factory
#  @device = @factory.devices.find(iddecode(params[:id]))
#  @upholds = @device.upholds
# 
#end
 

