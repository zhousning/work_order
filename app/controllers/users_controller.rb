class UsersController < ApplicationController
  layout "application_no_header"
  before_filter :authenticate_user!, :except=>[:alipay_notify]
  #protect_from_forgery :only=>[:alipay_notify]
  skip_before_filter :verify_authenticity_token, :only => [:alipay_notify]


  def center
    @user = current_user
  end
  
  def level
    @citrine = current_user.citrine
  end

  def mobile_authc_new
    @user = current_user
  end

  def mobile_authc_create
    account_password = params[:account_password]
    if account_password.blank? || user_authc_params[:name].blank? || user_authc_params[:identity].blank? || user_authc_params[:alipay].blank?
      redirect_to mobile_authc_new_user_url
    else
      @user = current_user 
      if @user.update(user_authc_params)
        @user.account.add_password(account_password)
        @user.produce_authc
        redirect_to authc_pay
      else
        redirect_to mobile_authc_new_user_url
      end
    end
  end

  def authc_pay
    Alipay::Service.create_direct_pay_by_user_wap_url(
      :out_trade_no      => current_user.authc_number,
      :subject           => "茶源实名认证",
      :total_fee         => Setting.systems.authc_pay,
      :return_url        => Rails.application.routes.url_helpers.alipay_return_users_url(:host => Setting.systems.host),
      :notify_url        => Rails.application.routes.url_helpers.alipay_notify_users_url(:host => Setting.systems.host)
    )
  end

  def alipay_return
    puts "alipay return >>>>>>>>>>>>>>"
    callback_params = params.except(*request.path_parameters.keys)
    if callback_params.any? && Alipay::Sign.verify?(callback_params)
      redirect_to  mobile_authc_status_user_url(current_user)
    else
      redirect_to mobile_authc_new_user_url(current_user)
    end
  end

  def alipay_notify
    puts "alipay notify >>>>>>>>>>>>>>"
    notify_params = params.except(*request.path_parameters.keys)
    if Alipay::Sign.verify?(notify_params) and Alipay::Notify.verify?(notify_params)
      user = User.find_by_authc_number(params[:out_trade_no])
      case params[:trade_status]
      when 'TRADE_SUCCESS'
        pass(user)
      when 'TRADE_FINISHED'
        pass(user)
      end

      render :text => 'success'
    else
      render :text => 'error'
    end
  end

  def mobile_authc_status
    @user = current_user 
  end


  private

    def user_params
      params.require(:user).permit(:email)
    end

    def user_authc_params
      params.require(:user).permit(:name, :identity, :alipay)
    end
    
    def pass(user)
      user.pass
      user.tree.add_count(1) if user.tree.count == 0 
      user.leaf.enable
      user.account.enable
      father = user.parent
      if father
        father.citrine.add_count(Setting.awards.ten_citrine)
        Consume.create(:category => Setting.consumes.category_friend_authc, :coin_cost => Setting.awards.ten_citrine, :status => Setting.consumes.status_success, :citrine_id => father.citrine.id)
        if grandpa = father.parent
          grandpa.citrine.add_count(Setting.awards.one_citrine) 
          Consume.create(:category => Setting.consumes.category_friend_authc, :coin_cost => Setting.awards.one_citrine, :status => Setting.consumes.status_success, :citrine_id => grandpa.citrine.id)
        end
      end
    end

end
