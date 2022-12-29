class FactoriesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource


  def bigscreen
    @factory = current_user.factories.find(iddecode(params[:id]))
    @other_quotas = [Setting.quota.inflow, Setting.quota.outflow, Setting.quota.outmud, Setting.quota.power]
    gon.lnt = @factory.lnt
    gon.lat = @factory.lat
    gon.title = @factory.name
  end
   
  def index
    @factory = Factory.new
   
    @factories = Factory.all
   
  end
   

   
  def show
   
    @factory = Factory.where(:id => params[:id]).first
   
  end
   

   
  def new
    @factory = Factory.new
    
    @factory.departments.build
    
  end
   

   
  def create
    @factory = Factory.new(factory_params)
    fct = Factory.find_by_name(Setting.admins.leader)
    @factory.parent = fct if @factory.parent.nil?

    if @factory.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
    @factory = Factory.where(:id => params[:id]).first
  end
   

   
  def update
    @factory = Factory.where(:id => params[:id]).first
   
    if @factory.update(factory_params)
      redirect_to edit_factory_path(@factory) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @factory = Factory.where(:id => params[:id]).first
   
    @factory.destroy
    redirect_to :action => :index
  end
   
  private
    def factory_params
      params.require(:factory).permit( :area, :name, :info, :lnt, :lat , :logo, departments_attributes: department_params, children_attributes: children_params)
    end
  
  
  
    def department_params
      [:id, :name, :info ,:_destroy]
    end
  
    def children_params
      [:id, :name,:_destroy]
    end
end

