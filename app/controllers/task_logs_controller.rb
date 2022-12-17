class TaskLogsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @task_log = TaskLog.new
   
    #@task_logs = TaskLog.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = TaskLog.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :wx_user_id => item.wx_user_id,
       
        :state => item.state
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @task_log = TaskLog.find(iddecode(params[:id]))
   
  end
   

   

   

   

   

   
  def destroy
   
    @task_log = TaskLog.find(iddecode(params[:id]))
   
    @task_log.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def task_log_params
      params.require(:task_log).permit( :wx_user_id, :state)
    end
  
  
  
end

