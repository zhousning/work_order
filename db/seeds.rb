# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#注释开始
role = Role.create(:name => Setting.roles.super_admin)

admin_permissions = Permission.create(:name => Setting.permissions.super_admin, :subject_class => Setting.admins.class_name, :action => "manage")

role.permissions << admin_permissions

user = User.new(:phone => Setting.admins.phone, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)
user.save!

user.roles = []
user.roles << role

AdminUser.create!(:phone => Setting.admins.phone, :email => Setting.admins.email, :password => Setting.admins.password, :password_confirmation => Setting.admins.password)

###区分厂区和集团用户是为了sidebar显示
@role_fctmgn = Role.where(:name => Setting.roles.role_fctmgn).first

##厂区管理者
@fctmgn = [@role_fctmgn]

@pollute = Company.create(:name => Setting.companies.pollute)
@water = Company.create(:name => Setting.companies.water)

@nwgc  = Factory.create!(:name => Setting.companies.pollute)
User.create!(:phone => "053701013708", :password => "swr0101", :password_confirmation => "swr0101", :name => Setting.companies.pollute, :roles => @fctmgn,    :factories => [@nwgc])

@swjt  = Factory.create!(:name => Setting.companies.water)
User.create!(:phone => "053701011818", :password => "water18180101", :password_confirmation => "water18180101", :name => Setting.companies.water, :roles => @fctmgn,    :factories => [@swjt])
#注释结束

WorkorderCtg.create!(:name => '热线', :company => @water)
WorkorderCtg.create!(:name => '户表开户', :company => @water)
WorkorderCtg.create!(:name => '大表开户', :company => @water)
WorkorderCtg.create!(:name => '报停', :company => @water)
WorkorderCtg.create!(:name => '销户', :company => @water)
WorkorderCtg.create!(:name => '投诉举报', :company => @water)
WorkorderCtg.create!(:name => '用户名变更', :company => @water)
WorkorderCtg.create!(:name => '用水分类申请', :company => @water)

Deploy.create!(:name => 'weixin')

