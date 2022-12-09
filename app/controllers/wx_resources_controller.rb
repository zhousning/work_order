class WxResourcesController < ApplicationController
  #skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :wxuser_exist?

  def img_upload

    if @wxuser.state != Setting.states.completed
      respond_to do |f|
        f.json{ render :json => {:state => 'error', :url => ''}.to_json}
      end
      return
    end

    uploader = WxEnclosureUploader.new
    if uploader.store!(params[:file])
      path = uploader.url
      respond_to do |f|
        f.json{ render :json => {:state => "success", :url => path}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => "error"}.to_json}
      end
    end
  end
end
