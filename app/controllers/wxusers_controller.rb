class WxusersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource
  
  def query_list
    @factory = my_factory
    @wxusers = @factory.wx_users.where(:state => Setting.states.completed).order('created_at DESC')
    obj = []
    @wxusers.each do |item|
      button = "<button class = 'button button-inverse button-small mr-1 assign-btn' type = 'button' data-id ='" + idencode(item.id).to_s + "'>分配</button>"
      obj << {
        :name => item.name,
        :phone => item.phone,
        :search => button,
      }
    end
    respond_to do |f|
      f.json{ render :json => {:info => obj}.to_json}
    end
  end


end
