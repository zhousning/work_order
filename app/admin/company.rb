ActiveAdmin.register Company  do

  permit_params  :area, :name, :info, :lnt, :lat, factories_attributes: [:id, :area, :name, :design, :info, :lnt, :lat, :_destroy]
  actions :all, :except => [:destroy]


  menu label: Setting.companies.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :area, :label => Setting.companies.area
  filter :name, :label => Setting.companies.name
  filter :info, :label => Setting.companies.info
  filter :lnt, :label => Setting.companies.lnt
  filter :lat, :label => Setting.companies.lat
  filter :created_at

  index :title=>Setting.companies.label + "管理" do
    selectable_column
    id_column
    
    column Setting.companies.area, :area
    column Setting.companies.name, :name
    column Setting.companies.info, :info
    column Setting.companies.lnt, :lnt
    column Setting.companies.lat, :lat

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.companies.label do
      
      f.input :area, :label => Setting.companies.area 
      f.input :name, :label => Setting.companies.name 
      f.input :lnt, :label => Setting.companies.lnt 
      f.input :lat, :label => Setting.companies.lat 
      f.input :info, :label => Setting.companies.info 

      f.inputs '工厂' do
        f.has_many :factories do |t|
          t.input :area, :label => Setting.factories.area 
          t.input :name, :label => Setting.factories.name 
          t.input :design, :label => Setting.factories.design
          t.input :plan, :label => Setting.factories.plan
          t.input :lnt, :label => Setting.factories.lnt 
          t.input :lat, :label => Setting.factories.lat 
          t.input :info, :label => Setting.factories.info 
        end
      end
    end
    f.actions
  end

  show :title=>Setting.companies.label + "信息" do
    attributes_table do
      row "ID" do
        company.id
      end
      
      row Setting.companies.area do
        company.area
      end
      row Setting.companies.name do
        company.name
      end
      row Setting.companies.info do
        company.info
      end
      row Setting.companies.lnt do
        company.lnt
      end
      row Setting.companies.lat do
        company.lat
      end

      row "创建时间" do
        company.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        company.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
