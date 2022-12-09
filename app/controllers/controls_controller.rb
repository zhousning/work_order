class ControlsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

  def index
    #gon.center = [116.605763, 35.444226] 
    #@factorie = current_user.factories.first
    #arr = [@factorie.lnt, @factorie.lat]
    #gon.center = arr
    #wx_users = @factorie.wx_users
    #@works = []
    #@pends = []
    #wx_users.each do |user|
    #  if user.task_state == Setting.states.working
    #    @works << user 
    #  else
    #    @pends << user
    #  end
    #end
  end

  def search
    search = params[:search]
    items = []
    if search.present?
      objs = CtgMtrl.search search 
      objs.each do |item|
        if item.stock
          items << {
            :name => item.name,
            :mdno => item.model_no,
            :count => item.stock.count,
            :fctname => item.factory.name
          }
        end
      end
    end

    respond_to do |f|
      f.json{ render :json => items.to_json}
    end
  end

  def search2
    ware = params[:ware_search]
    search = params[:search]
    if search.present?
      objs = []
      if ware == Setting.wares.water_item
        #objs = WaterItem.search search, fields: [:tag], match: :word_middle 
        objs = WaterItem.search search 
      elsif ware == Setting.wares.sewage_item
        objs = SewageItem.search search 
      elsif ware == Setting.wares.project_item
        objs = ProjectItem.search search
      elsif ware == Setting.wares.repair_part
        objs = RepairPart.search search
      elsif ware == Setting.wares.emergency
        objs = Emergency.search search
      elsif ware == Setting.wares.stuff
        objs = Stuff.search search
      end

      items = []
      objs.each do |item|
        items << {
          :name => item.name,
          :mdno => item.mdno,
          :fct  => item.fct,
          :count => item.count,
          :fctname => item.factory.name
        }
      end
    end
    respond_to do |f|
      f.json{ render :json => items.to_json}
    end
  end
      
end
