ActiveAdmin.register Permission  do

  permit_params  :name, :subject_class, :action, :description, permission_ids: []
  actions :all, :except => [:destroy]

      
  menu label: "权限管理" 
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :name, :label => Setting.permissions.name
  filter :created_at

  index :title=>Setting.permissions.label do
    selectable_column
    id_column
    
    column Setting.permissions.name, :name

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.permissions.label do
      f.input :name, :label => Setting.permissions.name 
      f.input :subject_class, :label => Setting.permissions.subject_class 
      f.input :action, :label => Setting.permissions.action 
      f.input :description, :label => Setting.permissions.description 
    end
    f.actions
  end

  show :title=>Setting.permissions.label + "信息" do
    attributes_table do
      row "ID" do
        permission.id
      end
      
      row Setting.permissions.name do
        permission.name
      end

      row Setting.permissions.subject_class do
        permission.subject_class
      end

      row Setting.permissions.action do
        permission.action
      end

      row Setting.permissions.description do
        permission.description
      end

      row "创建时间" do
        permission.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        permission.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end
end
