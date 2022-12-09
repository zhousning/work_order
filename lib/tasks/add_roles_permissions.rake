namespace 'db' do
  desc "Loading all models and their methods in roles table."
  task(:add_roles_permissions => :environment) do

    data = YAML.load_file("lib/tasks/data/role_permissions.yaml")
    data.each do |r|
      permission_arr = []
      lists = r['permissions'] || []
      lists.each do |p|
        controller = p['controller'].camelize.constantize
        actions = p['actions']
        pms = Permission.where(:subject_class => controller.permission, :action => actions)
        pms.each do |pers|
          permission_arr << pers 
        end
      end

      role_name = r['role_name'].strip
      level = r['level'].to_s.strip
      role = Role.where(:name => role_name, :level => level).first
      unless role
        Role.create(:name => role_name, :level => level, :permissions => permission_arr) 
      else
        role.permissions = []
        role.permissions << permission_arr
      end
    end
  end
end
