class Users::RegistrationsController < Devise::RegistrationsController
  layout "application_no_header"
  before_filter :configure_permitted_parameters

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [:name, :phone, :identity, :password, :password_confirmation])
    #devise_parameter_sanitizer.permit(:update_account, :keys => [:phone, :identity, :password, :password_confirmation])
  end

  #layout "application_mobile"
# before_action :configure_account_update_params, only: [:update]

  #def create
  #  #super
  #  #role = Role.find(params['company'])
  #  #if role && role.name != Setting.roles.super_admin
  #  #  super do |resource|
  #  #    if resource.persisted?
  #  #      resource.set_roles(params['company'])
  #  #      resource.set_profile
  #  #    end
  #  #  end
  #  #else
  #  #  redirect_to new_user_registration_url
  #  #end
  #end
  
  #def new
  #  super do|resource|
  #    if my_inviter = params[:inviter] || cookies['inviter']
  #      resource.inviter = my_inviter
  #      cookies['inviter'] = { :value => my_inviter }
  #    end
  #  end
  #end

  #def create
  #  super do |resource|
  #    if resource.persisted? and cookies['inviter']
  #      user_inviter = User.find_by_number( cookies['inviter'])
  #      if user_inviter
  #        resource.update_attribute(:parent_id, user_inviter.id)
  #        inviter_citrine = user_inviter.citrine
  #        inviter_citrine.add_count(Setting.awards.one_citrine)
  #        Consume.create(:category => Setting.consumes.category_friend_reg, :coin_cost => Setting.awards.one_citrine, :status => Setting.consumes.status_success, :citrine_id => inviter_citrine.id)
  #      end
  #    end
  #  end
  #end

  #def create
  #  code = params[:confirm_code]
  #  if !code.blank? && !cookies[:reg_code].blank? && code == cookies[:reg_code]
  #    cookies.delete :reg_code
  #    super do |resource|
  #      if resource.persisted? and cookies['inviter']
  #        user_inviter = User.find_by_number(cookies['inviter'])
  #        if user_inviter
  #          resource.update_attribute(:parent_id, user_inviter.id)
  #          inviter_citrine = user_inviter.citrine
  #          inviter_citrine.add_count(Setting.awards.one_citrine)
  #          Consume.create(:category => Setting.consumes.category_friend_reg, :coin_cost => Setting.awards.one_citrine, :status => Setting.consumes.status_success, :citrine_id => inviter_citrine.id)
  #          cookies.delete :inviter
  #        end
  #      end
  #    end
  #  else
  #    redirect_to new_user_registration_url
  #  end
  #end

  def after_sign_up_path_for(resource)
    #if resource.has_role?(Setting.roles.labour)
    #  edit_labour_url(resource.labour)
    #elsif resource.has_role?(Setting.roles.supervisor)
    #  edit_supervisor_url(resource.supervisor)
    #elsif resource.has_role?(Setting.roles.constructor)
    #  edit_constructor_url(resource.constructor)
    #elsif resource.has_role?(Setting.roles.prospector)
    #  edit_prospector_url(resource.prospector)
    #elsif resource.has_role?(Setting.roles.designer)
    #  edit_designer_url(resource.designer)
    #elsif resource.has_role?(Setting.roles.monitor)
    #  edit_monitor_co_url(resource.monitor_co)
    #elsif resource.has_role?(Setting.roles.agentor)
    #  edit_agentor_co_url(resource.agentor_co)
    #else
    #  root_url
    #end
  end



  #def after_inactive_sign_up_path_for(resource)
  #  sendmail_users_url
  #end
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_url
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
