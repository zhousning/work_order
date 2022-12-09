ActiveAdmin.register Role  do

  permit_params  :name, permission_ids: []

  menu label: "角色管理" 
  config.per_page = 20
  config.sort_order = "id_asc"
  actions :all, :except => [:destroy]

  
  filter :name, :label => Setting.roles.name
  filter :created_at

  index :title=>Setting.roles.label do
    selectable_column
    id_column
    
    column Setting.roles.name, :name

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.roles.label do
      
      f.input :name, :label => Setting.roles.name 
      f.input :permissions, :label => "权限", as: :check_boxes 
    end
    f.actions
  end

  show :title=>Setting.roles.label + "信息" do
    attributes_table do
      row "ID" do
        role.id
      end
      
      row Setting.roles.name do
        role.name
      end

      row "权限" do
        table_for role.permissions do
          column "权限明细",  :name
        end
      end

      row "创建时间" do
        role.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        role.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end
end
