class Users::SessionsController < Devise::SessionsController
  layout "application_no_header"
# before_action :configure_sign_in_params, only: [:create]

  def user_validate
    resource = User.find_for_database_authentication(phone: params[:user][:phone])
    return render :json => {:success => false} unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in :user, resource
      return render :json => {:success => true}
    else
      return render :json => {:success => false}
    end
  end

  def after_sign_in_path_for(resource)
    controls_path
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
