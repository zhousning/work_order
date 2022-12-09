# coding: utf-8

namespace :project do
  desc "project tasks"
  task :tasks do
    Rake::Task["db:create_folders"].invoke
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:add_permissions"].invoke
    Rake::Task["db:add_roles_permissions"].invoke #在data/role_permissions中设置默认角色和对应权限,这一步要在add_permission之后
    Rake::Task["db:seed"].invoke
    
    #Rake::Task["db:import_users"].invoke
    #Rake::Task["assets:precompile"].invoke
    #Rake::Task["kindeditor:assets"].invoke
  end
end
