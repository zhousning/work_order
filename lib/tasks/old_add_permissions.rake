namespace 'db' do
  desc "Loading all models and their methods in permissions table."
  task(:add_old_permissions => :environment) do
    arr = []
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/
        arr << entry.camelize.gsub('.rb', '').constantize
      end
    end
    
    #根据zh-cn配置文件中authorities的配置内容来添加权限,要设置哪些权限,只需要在其中添加对应action和title即可
    arr.each do |controller|
      puts controller.permission
      if controller.permission
        manage_title = I18n.t("authorities." + controller.controller_name + ".manage.title")
        write_permission(controller.permission, "manage", manage_title, manage_title) if (/translation missing/ =~ manage_title).nil?
        controller.action_methods.each do |method|
          title = I18n.t("authorities." + controller.controller_name + "." + method + ".title")
          if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ && (/translation missing/ =~ title).nil?
            name, cancan_action, action_desc = eval_cancan_action(controller.controller_name, method)
            write_permission(controller.permission, cancan_action, name, action_desc)  
          end
        end
      end
    end

  end
end

#def eval_cancan_action(controller_name, action)
#  case action.to_s
#  when "index"
#    name = I18n.t("authorities." + controller_name + ".index.title")
#    cancan_action = "index"
#  when "show", "search"
#    name = I18n.t("authorities." + controller_name + ".show.title")
#    cancan_action = "show"
#  when "new", "create"
#    name = I18n.t("authorities." + controller_name + ".new.title")
#    cancan_action = "create"
#  when "edit", "update"
#    name = I18n.t("authorities." + controller_name + ".edit.title")
#    cancan_action = "update"
#  when "delete", "destroy"
#    name = I18n.t("authorities." + controller_name + ".destroy.title")
#    cancan_action = "delete"
#  else
#    name = I18n.t("authorities." + controller_name + "." + action + ".title")
#    cancan_action = action.to_s
#  end
#  action_desc = name 
#
#  return name, cancan_action, action_desc
#end
#
#
#def write_permission(class_name, cancan_action, name, description)
#  permission  = Permission.where(["subject_class = ? and action = ?", class_name, cancan_action]).first 
#  unless permission
#    permission = Permission.new
#    permission.subject_class =  class_name
#    permission.action = cancan_action
#    permission.name = name
#    permission.description = description
#    permission.save
#  else
#    permission.name = name 
#    permission.description = description
#    permission.save
#  end
#end
#
