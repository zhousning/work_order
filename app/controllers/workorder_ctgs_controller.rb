class WorkorderCtgsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @factory = my_factory
    @workorder_ctg = WorkorderCtg.new
    @workorder_ctgs = WorkorderCtg.all.page( params[:page]).per( Setting.systems.per_page )
  end
   
  def new
    @factory = my_factory
    @workorder_ctg = WorkorderCtg.new
  end
   

   
  def create
    @factory = my_factory
    @workorder_ctg = WorkorderCtg.new(workorder_ctg_params)
    @workorder_ctg.company = @factory.company  

    if @workorder_ctg.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @factory = my_factory
    @workorder_ctg = WorkorderCtg.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @factory = my_factory
    @workorder_ctg = WorkorderCtg.find(iddecode(params[:id]))
    @workorder_ctg.company = @factory.company  
   
    if @workorder_ctg.update(workorder_ctg_params)
      redirect_to edit_factory_workorder_ctg_path(idencode(@factory.id), idencode(@workorder_ctg.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @workorder_ctg = WorkorderCtg.find(iddecode(params[:id]))
   
    @workorder_ctg.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def workorder_ctg_params
      params.require(:workorder_ctg).permit( :name)
    end
  
  
  
end

