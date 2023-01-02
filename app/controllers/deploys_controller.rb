class DeploysController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @deploy = Deploy.new
   
    @deploys = Deploy.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   
   
  def show
   
    @deploy = Deploy.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @deploy = Deploy.new
    
  end
   

   
  def create
    @deploy = Deploy.new(deploy_params)
     
    if @deploy.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @deploy = Deploy.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @deploy = Deploy.find(iddecode(params[:id]))
   
    if @deploy.update(deploy_params)
      redirect_to deploy_path(idencode(@deploy.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @deploy = Deploy.find(iddecode(params[:id]))
   
    @deploy.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def deploy_params
      params.require(:deploy).permit( :name, :start_time, :end_time, :expire, :appid, :secret, :key, :val1, :val2, :val3)
    end
  
  
  
end

