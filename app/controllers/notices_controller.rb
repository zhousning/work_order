class NoticesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @notices = Notice.all
  end
   

   
  def show
    @notice = Notice.find(params[:id])
  end
   

   
  def new
    @notice = Notice.new
    
  end
   

   
  def create
    @notice = Notice.new(notice_params)
    #@notice.user = current_user
    if @notice.save
      redirect_to @notice
    else
      render :new
    end
  end
   

   
  def edit
    @notice = Notice.find(params[:id])
  end
   

   
  def update
    @notice = Notice.find(params[:id])
    if @notice.update(notice_params)
      redirect_to notice_path(@notice) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @notice = Notice.find(params[:id])
    @notice.destroy
    redirect_to :action => :index
  end
   

  private
    def notice_params
      params.require(:notice).permit( :title, :content , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
end

