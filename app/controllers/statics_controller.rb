class StaticsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

  include StateModule

  def static_by_progress
    _start = params[:start].gsub(/\s/, '')
    _end = params[:end].gsub(/\s/, '')
    fct = params[:fct].gsub(/\s/, '')
    _start = Date.parse(_start)
    _end = Date.parse(_end) + 1

    @work_orders = WorkOrder.where(:created_at => [_start.._end], :factory_id => iddecode(fct))
    hash = Hash.new 
    hash[Setting.states.opening] = 0
    hash[Setting.states.assign] = 0
    hash[Setting.states.processing] = 0
    hash[Setting.states.completed] = 0
    @work_orders.each do |work_order|
      state = work_order.task_logs.last.state
      if state == Setting.states.opening || state == Setting.states.assign || state == Setting.states.completed
        hash[state] += 1
      else state == Setting.states.processing || state == Setting.states.processed || state == Setting.states.transfer
        hash[Setting.states.processing] += 1
      end
    end
    array = []
    hash.map do |k, v|
      array << {
        name: order_state(k),
        value: v
      }
    end
    respond_to do |f|
      f.json{ render :json => {:data => array}.to_json}
    end
  end

  def static_by_category
    _start = params[:start].gsub(/\s/, '')
    _end = params[:end].gsub(/\s/, '')
    fct = params[:fct].gsub(/\s/, '')
    _start = Date.parse(_start)
    _end = Date.parse(_end) + 1

    hash = Hash.new 
    ctg_hash = Hash.new
    @ctgs = WorkorderCtg.all
    
    @ctgs.each do |ctg|
      hash[ctg.to_s] = 0
      ctg_hash[ctg.id.to_s] =ctg.name
    end
    select_str = "count(id) as count, workorder_ctg_id"   
    @work_orders = WorkOrder.where(:pdt_date => [_start.._end], :factory_id => iddecode(fct)).select(select_str).group('workorder_ctg_id')
    @work_orders.each do |work_order|
      hash[work_order.workorder_ctg_id.to_s] = work_order.count
    end
    array = []
    hash.map do |k, v|
      array << {
        name: ctg_hash[k],
        value: v
      }
    end
    respond_to do |f|
      f.json{ render :json => {:data => array}.to_json}
    end
  end

  def static_count_perday
    _start = params[:start].gsub(/\s/, '')
    _end = params[:end].gsub(/\s/, '')
    fct = params[:fct].gsub(/\s/, '')
    xaxis = []
    data = []

    select_str = "count(id) as count, pdt_date"   
    @work_orders = WorkOrder.where(:pdt_date => [_start.._end], :factory_id => iddecode(fct)).select(select_str).group('pdt_date')
    @work_orders.each do |work_order|
      xaxis << work_order.pdt_date 
      data << work_order.count 
    end
    respond_to do |f|
      f.json{ render :json => {:xaxis => xaxis, :data => data}.to_json}
    end
  end
end
