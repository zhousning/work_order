ActiveAdmin.register AdminUser do

  permit_params :email, :password, :password_confirmation

  actions :all, :except => [:edit, :destroy]

  menu label: "管理员", :priority => 2
  config.per_page = 20
  config.sort_order = "id_asc"

  index :title=>"管理员" do
    selectable_column
    id_column
    column "邮箱", :email
    column "登录次数", :sign_in_count
    column "创建时间", :created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin详情" do
      f.input :email, :label => "邮箱"
      f.input :password, :label => "密码"
      f.input :password_confirmation, :label => "确认密码"
    end
    f.actions
  end

  show :title=>:email do
    attributes_table do
      row "ID" do
        admin_user.id
      end
      row "邮箱" do
        admin_user.email
      end
      row "密码" do
        admin_user.password
      end
      row "确认密码" do
        admin_user.password_confirmation
      end
      row "登录次数" do
        admin_user.sign_in_count
      end
      row "创建时间" do
        admin_user.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        admin_user.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
