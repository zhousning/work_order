ActiveAdmin.register Department  do

  permit_params  :name, :info
  actions :all, :except => [:destroy]

  menu label: Setting.departments.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :name, :label => Setting.departments.name
  filter :info, :label => Setting.departments.info
  filter :created_at

  index :title=>Setting.departments.label + "管理" do
    selectable_column
    id_column
    
    column Setting.departments.name, :name
    column Setting.departments.info, :info

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.departments.label do
      
      f.input :name, :label => Setting.departments.name 
      f.input :info, :label => Setting.departments.info 
    end
    f.actions
  end

  show :title=>Setting.departments.label + "信息" do
    attributes_table do
      row "ID" do
        department.id
      end
      
      row Setting.departments.name do
        department.name
      end
      row Setting.departments.info do
        department.info
      end

      row "创建时间" do
        department.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        department.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
