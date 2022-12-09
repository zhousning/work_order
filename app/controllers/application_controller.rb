require 'json'
require 'restclient'

class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  before_action :configure_permitted_parameters_name, if: :devise_controller?

  protect_from_forgery with: :exception

  before_filter :user_access_log


  def alipay_client
    client = Alipay::Client.new(
      url: ENV['ALIPAY_API'],
      app_id: ENV['APP_ID'],
      app_private_key: ENV['APP_PRIVATE_KEY'],
      alipay_public_key: ENV['ALIPAY_PUBLIC_KEY']
    )
  end

  def user_access_log
    session_id = session[:session_id] || ""
    user_id = (current_user && current_user.id) || ""
    user_name = (current_user && current_user.name) || ""
    STAT_LOGGER.info "[access]\t#{request.request_method}\t#{request.url}\t#{request.referer}\t#{request.remote_ip}\t#{request.user_agent}\t#{session_id}\t#{user_id}\t#{user_name}"
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  
  protected

    def self.permission
      return name = controller_name.classify.constantize rescue nil
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end 
    def load_permissions
      current_user.roles.each do |role|
        @current_permissions = role.permissions.collect{|i| [i.subject_class, i.action]}
      end
    end

    def is_super_admin?
      redirect_to root_path and return unless current_user.super_admin?
    end

    def configure_permitted_parameters_name
      added_attrs = [:phone, :email, :password, :password_confirmation, :remember_me, :inviter]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    def convert_to_md5(value)
      Digest::MD5.hexdigest(value) unless value.blank?
    end

    def idencode(value)
      (value.to_i*99 + 4933)*3 
    end

    def iddecode(value)
      (value.to_i/3 - 4933)/99 
    end

    def months
      {
        Setting.months.one    => Setting.months.one_t, 
        Setting.months.two    => Setting.months.two_t, 
        Setting.months.three  => Setting.months.three_t,
        Setting.months.four   => Setting.months.four_t, 
        Setting.months.five   => Setting.months.five_t,
        Setting.months.six    => Setting.months.six_t,
        Setting.months.seven  => Setting.months.seven_t,
        Setting.months.eight  => Setting.months.eight_t,
        Setting.months.nine   => Setting.months.nine_t, 
        Setting.months.ten    => Setting.months.ten_t,
        Setting.months.eleven => Setting.months.eleven_t,
        Setting.months.twelve => Setting.months.twelve_t
      }

    end
  
    def wxuser_exist?
      @wxuser = WxUser.find_by(:openid => params[:id])
      flag = @wxuser ? true : false
      unless flag
        respond_to do |f|
          f.json{ render :json => {:state => "error"}.to_json}
        end
        return
      end
    end

    def chemicals_hash
      hash = Hash.new
      ctgs = ChemicalCtg.all
      ctgs.each do |f|
        hash[f.code] = f.name
      end
      hash
    end

    def mudfcts_hash(factory)
      hash = Hash.new
      mudfcts = factory.mudfcts
      mudfcts.each do |f|
        hash[f.id.to_s] = f.name
      end
      hash
    end

    def my_factory
      @factory = current_user.factories.find(iddecode(params[:factory_id]))
    end

    def my_cpy_factory
      @factory = current_user.factories.first
    end

    def user_gender(gender)
      flag = ''
      if gender == Setting.systems.man_no
        flag = Setting.systems.man
      else gender == Setting.systems.woman_no
        flag = Setting.systems.woman
      end

    end

    def worker_state(state)
      str = ''
      if state == Setting.states.ongoing
        str = '未验证'
      elsif state == Setting.states.processing
        str = '处理中'
      elsif state == Setting.states.canceled ||  state == Setting.states.error
        str = '处理失败'
      elsif state == Setting.states.deleting
        str = '删除中'
      elsif state == Setting.states.completed
        str = '已验证'
      end
      str
    end

    def wexin_token
      url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + ENV['WX_APPID'] + "&secret=" + ENV['WX_SECRET'] 
      @wexin = Deploy.find_by_name('weixin')
      now = Time.now
      access_token = '' 
      if !@wexin.key && now - @wexin.start_time < @wexin.expire 
        access_token = @wexin.key 
      else
        RestClient.get(url) do |response|
          body = JSON.parse(response.body)
          errcode = body['errcode']
          if errcode != 0 
            access_token = body['access_token']
            expire = body['expires_in']
            @wexin.update_attributes!(:key => access_token, :expire => expire)
          end
        end
      end
      return access_token 
    end
end
