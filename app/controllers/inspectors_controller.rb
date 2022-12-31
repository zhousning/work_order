class InspectorsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource 


  def index
    @factory = my_factory
    @inspectors = []
    fct_recurrence(@factory, @inspectors)
    @inspectors = @inspectors.flatten
  end

  def receive 
    @wxuser = WxUser.find(iddecode(params[:id]))
    @wxuser.completed
    redirect_to :action => :index
  end

  def reject 
    @wxuser = WxUser.find(iddecode(params[:id]))
    @wxuser.ongoing
    redirect_to :action => :index
  end

  private
    def fct_recurrence(factory, inspectors)
      wxusers = factory.wx_users.order('state DESC')
      inspectors << wxusers unless wxusers.blank?
      
      unless factory.children.blank?
        factory.children.each do |fct|
          fct_recurrence(fct, inspectors)
        end
      end
    end

end
