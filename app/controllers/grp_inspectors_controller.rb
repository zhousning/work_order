class GrpInspectorsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource 


  def index
    if current_user.has_role?(Setting.roles.role_cpy)
      @factory = my_cpy_factory
      @useinspectors = @factory.wx_users.where(:state => Setting.states.completed)
    else
      @useinspectors = WxUser.where(:state => Setting.states.completed)
    end
  end

  def delete_inspector 
    @factory = my_cpy_factory
    @wxuser = @factory.wx_users.find(iddecode(params[:id]))
    if @wxuser.state == Setting.states.ongoing
      if SignLog.where(:wx_user_id => @wxuser.id).destroy_all && @wxuser.destroy
        respond_to do |f|
          f.json{ render :json => {:state => 'success'}.to_json}
        end
      else
        respond_to do |f|
          f.json{ render :json => {:state => 'error'}.to_json}
        end
      end
    end
  end

  def query_unuse
    objs = []
    if current_user.has_role?(Setting.roles.role_cpy)
      @factory = my_cpy_factory
      @uninspectors = @factory.wx_users.where(:state => Setting.states.ongoing)
      @uninspectors.each_with_index do |wx_user, index|
        devices = ''
        wx_user.devices.each do |d|
          devices += d.name + ', '
        end
        objs << {
          :index => index,
          :name => wx_user.name,
          :nickname => wx_user.nickname,
          :phone => wx_user.phone,
          :sites => devices,
          :button => "<button class='button button-caution button-small mr-3 inspector-delete-btn' data-id='" + idencode(wx_user.id).to_s + "'>删除</button>"
        }
      end
    else
      @uninspectors = WxUser.where(:state => Setting.states.ongoing)
      @uninspectors.each_with_index do |wx_user, index|
        devices = ''
        wx_user.devices.each do |d|
          devices += d.name + ', '
        end
        objs << {
          :index => index,
          :name => wx_user.name,
          :nickname => wx_user.nickname,
          :phone => wx_user.phone,
          :sites => devices
        }
      end
    end
    respond_to do |f|
      f.json{ render :json => objs.to_json}
    end
  end
end
