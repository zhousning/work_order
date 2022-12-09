class GrpDevicesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource
   
  def index
  end

  def query_all 
    obj = []
    if current_user.has_role?(Setting.roles.role_cpy)
      @factory = my_cpy_factory
      @devices = @factory.devices
      @devices.each do |item|
        obj << {
          :id => idencode(item.id),
          :idno => item.idno,
          :name => item.name,
          :mdno => item.mdno,
          :unit => item.unit,
          :state => item.state,
          :pos => item.pos,
          :supplier => item.supplier,
          :pos_no => item.pos_no,
          :search => '',
          :fct => item.factory.name
        }
      end
    else
      @devices = Device.all
      @devices.each do |item|
        search = "<a class='button button-royal button-small mr-3' href='/grp_devices/" + idencode(item.id).to_s + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/grp_devices/" + idencode(item.id).to_s + "'>删除</a>"
        obj << {
          :id => idencode(item.id),
          :idno => item.idno,
          :name => item.name,
          :mdno => item.mdno,
          :unit => item.unit,
          :state => item.state,
          :pos => item.pos,
          :supplier => item.supplier,
          :pos_no => item.pos_no,
          :fct => item.factory.name
        }
      end
    end
   
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def edit
   
    @device = Device.find(iddecode(params[:id]))
   
  end
   
  def update
   
    @device = Device.find(iddecode(params[:id]))
   
    if @device.update(device_params)
      redirect_to edit_grp_device_path(idencode(@device.id)) 
    else
      render :edit
    end
  end
   
  def destroy
   
    @device = Device.find(iddecode(params[:id]))
    wxusers = @device.wx_users
   
    @device.destroy if wxusers.blank?
    redirect_to :action => :index
  end

  def xls_download
    send_file File.join(Rails.root, "templates", "站点模板.xlsx"), :filename => "站点模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  def parse_excel
    @factory = Factory.find(iddecode(params['fct'])) 
    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)

    idno = ""
    name = ""
    mdno = "" 
    unit = ""
    life = ""
    state = ""
    desc = ""
    supplier = ""
    mfcture = ""
    out_date = ""
    pos = ""
    pos_no = ""
    mount_date = ""

    results["Sheet1"][1..-1].each do |items|
      items.each do |k, v|
        if !(/A/ =~ k).nil?
          idno = v.nil? ? "" : v.to_s.strip 
        elsif !(/B/ =~ k).nil?
          name = v.nil? ? "" : v.to_s.strip  
        elsif !(/C/ =~ k).nil?
          mdno = v.nil? ? "" : v.to_s.strip  
        elsif !(/D/ =~ k).nil?
          unit = v.nil? ? "" : v.to_s.strip  
        elsif !(/E/ =~ k).nil?
          supplier = v.nil? ? "" : v.to_s.strip  
        elsif !(/F/ =~ k).nil?
          pos = v.nil? ? "" : v.to_s.strip  
        elsif !(/G/ =~ k).nil?
          pos_no = v.nil? ? "" : v.to_s.strip  
        elsif !(/H/ =~ k).nil?
          desc = v.nil? ? "" : v.to_s.strip  
        elsif !(/I/ =~ k).nil?
          state = v.nil? ? "施工中" : v.to_s.strip
        end
      end

      device = @factory.devices.where(:mdno => mdno, :unit => unit, :supplier => supplier).first
      if device
        next 
      else
        @device = Device.new(:idno => idno, :name => name, :mdno => mdno, :unit => unit, :supplier => supplier, :pos => pos, :pos_no => pos_no, :desc  => desc, :state => state, :factory => @factory)

        @device.save
      end
    end

    redirect_to :action => :index
  end 

  private
    def device_params
      params.require(:device).permit( :idno, :name, :mdno, :unit, :out_date, :mount_date, :supplier, :mfcture, :pos, :pos_no, :life, :desc , :avatar, :state)
    end
  
   
  
end
