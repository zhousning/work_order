module GroupBase
  def destroy_base(that)
    @project = get_project
    @project_group = @project.project_group 
    obj = that.underscore
    eval(
         "@#{obj} = @project_group.group_#{obj}s.where(:project_group_id => params[:project_group_id], :#{obj}_id => params[:id])[0]\n
          @#{obj}.destroy"
         )
    redirect_to project_project_groups_url(@project) 
  end

  def get_project
    @user = CptDepUser.find_by_user_id(current_user.id)
    project_groups = @user.project_groups
    project = nil
    project_groups.each do |p|
      project = p.project if p.project.id == params[:project_id].to_i
    end
    project
  end
  
end
