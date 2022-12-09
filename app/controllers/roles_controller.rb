class RolesController < ApplicationController
  layout "application_control"
  load_and_authorize_resource :except => [:show]
  #before_filter :is_super_admin?

  def new
    @role = Role.new
    permission_group(Permission.all)
    @role_permissions = @role.permissions.collect{|p| p.id}
  end

  def create
    @role = Role.new(role_params)
    @role.set_permissions(params[:permissions]) 
    if @role.save
      redirect_to @role
    else
      render :new
    end
  end

  def index
    @roles = Role.all.reject{|p| p.name == Setting.roles.super_admin}
  end

  def show
    @role = Role.find(params[:id])
    permission_group(@role.permissions)
  end

  def edit
    @role = Role.find(params[:id])
    permission_group(Permission.all)
    @role_permissions = @role.permissions.collect{|p| p.id}
  end

  def update
    @role = Role.find(params[:id])
    @role.set_permissions(params[:permissions])
    if @role.update(role_params)
      redirect_to roles_path
    else
      @permissions = Permission.all
      render :edit
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    redirect_to roles_path
  end

  private

    def role_params
      params.require(:role).permit(:name)
    end

    def permission_group(permission)
      @permissions = [] 
      permissions_all = permission.order("subject_class").reject{|p| p.name == Setting.permissions.super_admin || p.subject_class == Setting.roles.class_name}

      if permissions_all.size > 0
        permissions_item = []
        class_name = permissions_all.first.subject_class
        permissions_all.each_with_index do |p, i|
          if class_name == p.subject_class
            permissions_item << p
          else
            @permissions << permissions_item
            permissions_item = []
            permissions_item << p 
            class_name = p.subject_class
          end

          if i== permissions_all.size-1 
            @permissions << permissions_item
          end
        end
      end
    end
end
