class ControlsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

  def index
    if current_user.has_role?(Setting.roles.role_fct) || current_user.has_role?(Setting.roles.role_fctmgn)
      @factory = current_user.factories.first
      gon.fct = idencode(@factory.id)
      @inspectors = []
      fct_recurrence(@factory, @inspectors)
      @wxusers = @inspectors.flatten.count

      work_orders = @factory.work_orders.where(:pdt_date => Date.today)
      hash = Hash.new 
      hash[Setting.states.opening] = 0
      hash[Setting.states.assign] = 0
      hash[Setting.states.processing] = 0
      hash[Setting.states.completed] = 0
      work_orders.each do |work_order|
        state = work_order.task_logs.last.state
        if state == Setting.states.opening || state == Setting.states.assign || state == Setting.states.completed
          hash[state] += 1
        else state == Setting.states.processing || state == Setting.states.processed || state == Setting.states.transfer
          hash[Setting.states.processing] += 1
        end
      end
      @worker_orders = hash
      @worker_orders['count'] = work_orders.count 
    end
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
