class WxAuthsController < ApplicationController
  include BaiduFace
  #skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :wxuser_exist?, :only => [:auth_process]
  
  def auth_process
    body = search_face(params[:photo])
    @device = @wxuser.devices.find(params[:equipment])
    longitude = params[:longitude]
    latitude = params[:latitude]

    if body["error_code"] == 0
      users = body['result']['user_list']
      user = users[0]
      worker = Worker.find_by_idno(user["user_id"])
      @sign_log = SignLog.new(:sign_date => Date.today, :wx_user_id => @wxuser.id, :device_id => @device.id, :worker => worker, :avatar => params[:photo], :longitude => longitude, :latitude => latitude) 
 
      if @sign_log.save
        respond_to do |f|
          f.json{ render :json => {:state => "success", :name => worker.name}.to_json}
        end
      else
        respond_to do |f|
          f.json{ render :json => {:state => "error"}.to_json}
        end
      end
    else
      respond_to do |f|
        f.json{ render :json => {:state => "error"}.to_json}
      end
    end
  end
end

#sign_log = worker.sign_logs.where(:sign_date => Date.today, :device_id => @device.id).first 
#if sign_log.nil?
#  @sign_log = SignLog.new(:sign_date => Date.today, :wx_user_id => @wxuser.id, :device_id => @device.id, :worker => worker, :avatar => params[:photo], :longitude => longitude, :latitude => latitude) 
#
#  if @sign_log.save
#    respond_to do |f|
#      f.json{ render :json => {:state => "success", :name => worker.name}.to_json}
#    end
#  else
#    respond_to do |f|
#      f.json{ render :json => {:state => "error"}.to_json}
#    end
#  end
#else
#  respond_to do |f|
#    f.json{ render :json => {:state => "success", :name => worker.name}.to_json}
#  end
#end

#阿里云认证方法暂时不用
#require 'aliyunsdkcore'
#require 'open-uri'
#def aliauth_process 
#  worker = Worker.first
#  imageA = worker.avatar_base
#  imageB = image_to_base64(params[:photo])
#  client = RPCClient.new(
#    access_key_id:     ENV['ACCESS_KEY_ID'],
#    access_key_secret: ENV['ACCESS_KEY_SECRET'],
#    endpoint: 'https://facebody.cn-shanghai.aliyuncs.com',
#    api_version: '2019-12-30'
#  )
#  
#  response = client.request(
#    action: 'CompareFace',
#    params: {
#      #"ImageURLA": "http://viapi-test.oss-cn-shanghai.aliyuncs.com/viapi-3.0domepic/facebody/CompareFace/CompareFace-right1.png",
#      #"ImageURLB": "http://viapi-test.oss-cn-shanghai.aliyuncs.com/viapi-3.0domepic/facebody/CompareFace/CompareFace-left1.png"
#      "ImageDataA": imageA,
#      "ImageDataB": imageB,
#    },
#    opts: {
#      method: 'POST',
#      format_params: true
#    }
#  )
#  
#  puts response
#
#  respond_to do |f|
#    f.json{ render :json => {:state => "success"}.to_json}
#  end
#end
#def image_to_base64(photo)
#  tempfile = open(photo)
#  image_base64 = Base64.encode64(File.read(tempfile)).gsub(/\s/, '')
#  tempfile.close
#  image_base64
#end

