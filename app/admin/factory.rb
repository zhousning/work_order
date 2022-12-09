ActiveAdmin.register Factory  do

  permit_params  :area, :name, :info, :lnt, :lat

  menu label: Setting.factories.label
  config.per_page = 20
  config.sort_order = "id_asc"
  actions :all, :except => [:destroy]

  
  filter :area, :label => Setting.factories.area
  filter :name, :label => Setting.factories.name
  filter :info, :label => Setting.factories.info
  filter :lnt, :label => Setting.factories.lnt
  filter :lat, :label => Setting.factories.lat
  filter :created_at

  index :title=>Setting.factories.label + "管理" do
    selectable_column
    id_column
    
    column Setting.factories.area, :area
    column Setting.factories.name, :name
    column Setting.factories.info, :info
    column Setting.factories.lnt, :lnt
    column Setting.factories.lat, :lat

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.factories.label do
      
      f.input :area, :label => Setting.factories.area 
      f.input :name, :label => Setting.factories.name 
      f.input :info, :label => Setting.factories.info 
      f.input :lnt, :label => Setting.factories.lnt 
      f.input :lat, :label => Setting.factories.lat 
    end
    f.actions
  end

  show :title=>Setting.factories.label + "信息" do
    attributes_table do
      row "ID" do
        factory.id
      end
      
      row Setting.factories.area do
        factory.area
      end
      row Setting.factories.name do
        factory.name
      end
      row Setting.factories.info do
        factory.info
      end
      row Setting.factories.lnt do
        factory.lnt
      end
      row Setting.factories.lat do
        factory.lat
      end

      row "创建时间" do
        factory.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        factory.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
