ActiveAdmin.register Notice  do

  permit_params  :title, :content

  menu label: Setting.notices.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :title, :label => Setting.notices.title
  filter :content, :label => Setting.notices.content
  filter :created_at

  index :title=>Setting.notices.label + "管理" do
    selectable_column
    id_column
    
    column Setting.notices.title, :title
    column Setting.notices.content, :content

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.notices.label do
      
      f.input :title, :label => Setting.notices.title 
      f.kindeditor :content, :label => Setting.notices.content 
    end
    f.actions
  end

  show :title=>Setting.notices.label + "信息" do
    attributes_table do
      row "ID" do
        notice.id
      end
      
      row Setting.notices.title do
        notice.title
      end
      row Setting.notices.content do
        notice.content.html_safe
      end

      row "创建时间" do
        notice.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        notice.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
