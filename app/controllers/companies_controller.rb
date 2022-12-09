class CompaniesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @company = Company.new
   
    @companies = Company.all
   
  end
   

   
  def show
   
    @company = Company.where(:id => params[:id]).first
   
  end
   

   
  def new
    @company = Company.new
    
    @company.factories.build
    
  end
   

   
  def create
    @company = Company.new(company_params)
     
    #@company.user = current_user
     
    if @company.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @company = Company.where(:id => params[:id]).first
   
  end
   

   
  def update
   
    @company = Company.where(:id => params[:id]).first
   
    if @company.update(company_params)
      redirect_to company_path(@company) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @company = Company.where(:id => params[:id]).first
   
    @company.destroy
    redirect_to :action => :index
  end
   

  

  

  
  def xls_download
    send_file File.join(Rails.root, "public", "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
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
    def company_params
      params.require(:company).permit( :area, :name, :info, :lnt, :lat , :logo, factories_attributes: factory_params)
    end
  
  
  
    def factory_params
      [:id, :area, :name, :info, :lnt, :lat ,:_destroy]
    end
  
end

