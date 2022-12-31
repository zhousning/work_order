class WxusersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource
  
  def query_list
    @factory = my_factory
    @workorder = WorkOrder.find(iddecode(params[:taskid]))
    @wxusers = []
    fct_recurrence(@factory, @wxusers)
    @wxusers = @wxusers.flatten

    obj = []
    @wxusers.each do |item|
      orderlog = OrderLog.where(:work_order => @workorder, :wx_user => item).last 
      button = ""
      state = ""
      if !orderlog
        button = "<button class = 'button button-inverse button-small mr-1 assign-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>分配</button>"
      else
        state = order_log_state(orderlog.state)
      end
      obj << {
        :name => item.name,
        :phone => item.phone,
        :dept => item.factories.first.name,
        :state => state,
        :search => button
      }
    end
    respond_to do |f|
      f.json{ render :json => {:info => obj}.to_json}
    end
  end

  private
    def fct_recurrence(factory, inspectors)
      wxusers = factory.wx_users.where(:state => Setting.states.completed).order('created_at DESC')
      inspectors << wxusers unless wxusers.blank?
      
      unless factory.children.blank?
        factory.children.each do |fct|
          fct_recurrence(fct, inspectors)
        end
      end
    end


end
