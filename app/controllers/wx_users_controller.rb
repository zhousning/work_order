require 'restclient'
require 'json'

class WxUsersController < ApplicationController
  #skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  before_filter :wxuser_exist?, :except => [:update, :get_userid]

  def update 
    wxuser = WxUser.find_by(:openid => params[:id])
    respond_to do |f|
      if wxuser.update(wx_user_params)
        f.json { render :json => {:status => "wxuser update success" }.to_json}
      else
        f.json { render :json => {:status => "wxuser update error"}.to_json}
      end
    end
  end

  def get_userid
    encryptedData = params[:encryptedData]
    iv = params[:iv]
    url = "https://api.weixin.qq.com/sns/jscode2session"
    data = {
      appid: ENV['WX_APPID'], 
      secret: ENV['WX_SECRET'],
      js_code: params[:code].to_s,
      grant_type: 'authorization_code'
    }
    response = RestClient.get url, params: data, :accept => :json
    body = JSON.parse(response.body)
    unless body["errcode"]
      openid = body["openid"]
      session_key = body["session_key"]

      @wxuser = WxUser.find_by(:openid => openid)
      unless @wxuser
        @wxuser = WxUser.new(:openid => openid)
        if @wxuser.save
          number = @wxuser.number
          @role_wx = Role.where(:name => Setting.roles.role_wx).first
          @role_wx_device    = Role.where(:name => Setting.roles.role_wx_device).first
          @role_wx_worker    = Role.where(:name => Setting.roles.role_wx_worker).first
          @role_wx_sign_log  = Role.where(:name => Setting.roles.role_wx_sign_log).first
          @wxmgn = [@role_wx, @role_wx_worker, @role_wx_device, @role_wx_sign_log]
          
          User.create!(:phone => number, :password => number, :password_confirmation => number, :name => "签到负责人", :roles => @wxmgn)
        end
      end

      respond_to do |f|
        f.json { render :json => {:state => 'success', :openId => openid }.to_json }
      end
    else
      respond_to do |f|
        f.json { render :json => {:state => 'error' }.to_json }
      end
    end
  end

  def fcts
    factories = Company.all
    fct_objs = []
    factories.each do |fct|
      fct_objs << fct.name 
    end

    respond_to do |f|
      f.json { render :json => {fcts: fct_objs}.to_json }
    end
  end

  def areas
    @company = Company.find_by_name(params[:fct])
    factories = []
    @factories = @company.factories
    @factories.each do |fct|
      factories << fct.name 
    end

    respond_to do |f|
      f.json { render :json => {areas: factories}.to_json }
    end
  end

  def streets
    area = params[:area]
    fcts = Device.where(:mdno => area).order('unit')
    hash = Hash.new
    objs = []
    fcts.each do |fct|
      #hash[fct.unit] = [] if hash[fct.unit].nil?
      #hash[fct.unit]  << {:value => idencode(fct.id).to_s, :name => fct.name}
      objs  << {:value => idencode(fct.id).to_s, :name => fct.unit + '-' + fct.name}
    end
    respond_to do |f|
      f.json { render :json => objs.to_json }
    end
  end

  
  #第一版街道
  #def streets
  #  objs = []
  #  fcts = Device.where(:mdno => params[:area]).select('unit').uniq
  #  fcts.each do |fct|
  #    objs << fct.unit
  #  end
  #  respond_to do |f|
  #    f.json { render :json => objs.to_json }
  #  end
  #end

  def sites
    objs = []
    area = params[:area]
    street = params[:street]
    fcts = Device.where(:mdno => area, :unit => street)
    fcts.each do |fct|
      objs << {:value => idencode(fct.id).to_s, :name => fct.name}
    end
    respond_to do |f|
      f.json { render :json => objs.to_json }
    end
  end

  def set_fct
    factory = Factory.find_by_name(params[:fct])
    wxuser = WxUser.find_by(:openid => params[:id])
    if wxuser.state != Setting.states.completed
      respond_to do |f|
        if wxuser.update_attributes(:state => Setting.states.ongoing, :factories => [factory], :name => params[:name], :phone => params[:phone] )
          f.json { render :json => {:status => "success" }.to_json}
        else
          f.json { render :json => {:status => "error"}.to_json}
        end
      end
    end
  end

  def status
    wxuser = WxUser.find_by(:openid => params[:id])
    devices = wxuser.devices
    device_name = ""
    devices.each do |d|
      device_name += d.name + " "
    end
    respond_to do |f|
      if wxuser.state == Setting.states.ongoing
        f.json { render :json => {:status => Setting.states.ongoing }.to_json}
      else
        owner = wxuser.factories.first.name
        f.json { render :json => {:status => Setting.states.completed, :name => wxuser.name, :phone => wxuser.phone, :fct => device_name, :owner => owner}.to_json}
      end
    end
  end

  def identity 
    wxuser = WxUser.find_by(:openid => params[:id])
    respond_to do |f|
      f.json { render :json => {:identity => wxuser.number}.to_json}
    end
  end

  private
    def wx_user_params
      params.require(:wx_user).permit(:nickname, :avatarurl, :gender, :city, :province, :country, :language, :name, :phone)
    end                                  

end
