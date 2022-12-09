class DepartmentsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @department = Department.new
   
    @departments = current_user.departments
   
  end
   

   
  def show
   
    @department = Department.where(:user => current_user, :id => params[:id]).first
   
  end
   

   
  def new
    @department = Department.new
    
  end
   

   
  def create
    @department = Department.new(department_params)
     
    @department.user = current_user
     
    if @department.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @department = Department.where(:user => current_user, :id => params[:id]).first
   
  end
   

   
  def update
   
    @department = Department.where(:user => current_user, :id => params[:id]).first
   
    if @department.update(department_params)
      redirect_to department_path(@department) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @department = Department.where(:user => current_user, :id => params[:id]).first
   
    @department.destroy
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
    def department_params
      params.require(:department).permit( :name, :info)
    end
  
  
  
end

