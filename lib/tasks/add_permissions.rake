namespace 'db' do
  desc "Loading all permissions in permissions table."
  task(:add_permissions => :environment) do

    data = YAML.load_file("lib/tasks/data/permissions.yaml")
    data.each do |r|
      controller = r['controller'].camelize.constantize
      actions = r['actions']

      actions.each do |action|
        #controller_name = controller.controller_name
        #puts controller_name
        #name, cancan_action, action_desc = eval_cancan_action(controller_name, action)
        #write_permission(controller.permission, cancan_action, name, action_desc)  
        name, cancan_action, action_desc = eval_cancan_action(controller.controller_name, action)
        write_permission(controller.permission, cancan_action, name, action_desc)  
      end

    end
  end
end

def eval_cancan_action(controller_name, action)
  #controller_name = controller_name.pluralize.underscore
  name = I18n.t(controller_name + "." + action + ".title")

  case action
  when "index"
    cancan_action = "index"
  when "show", "search"
    cancan_action = "show"
  when "new", "create"
    cancan_action = "create"
  when "edit", "update"
    cancan_action = "update"
  when "delete", "destroy"
    cancan_action = "destroy"
  else
    cancan_action = action
  end
  action_desc = name 

  return name, cancan_action, action_desc
end


def write_permission(class_name, cancan_action, name, description)
  permission  = Permission.where(["subject_class = ? and action = ?", class_name, cancan_action]).first 
  unless permission
    permission = Permission.new
    permission.subject_class =  class_name
    permission.action = cancan_action
    permission.name = name
    permission.description = description
    permission.save
  else
    permission.name = name 
    permission.description = description
    permission.save
  end
end

