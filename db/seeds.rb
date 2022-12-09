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

#@user = User.create!(:phone => "15763703188", :password => "15763703188", :password_confirmation => "15763703188")

###区分厂区和集团用户是为了sidebar显示
@role_fct = Role.where(:name => Setting.roles.role_fct).first
@role_grp = Role.where(:name => Setting.roles.role_grp).first

@role_device    = Role.where(:name => Setting.roles.role_device).first
@role_inspector = Role.where(:name => Setting.roles.role_inspector).first
@role_worker    = Role.where(:name => Setting.roles.role_worker).first
@role_sign_log  = Role.where(:name => Setting.roles.role_sign_log).first

#@role_cpy_device    = Role.where(:name => Setting.roles.role_cpy_device).first
#@role_cpy_inspector = Role.where(:name => Setting.roles.role_cpy_inspector).first
#@role_cpy_worker    = Role.where(:name => Setting.roles.role_cpy_worker).first
#@role_cpy_sign_log  = Role.where(:name => Setting.roles.role_cpy_sign_log).first

@role_grp_device    = Role.where(:name => Setting.roles.role_grp_device).first
@role_grp_inspector = Role.where(:name => Setting.roles.role_grp_inspector).first
@role_grp_worker    = Role.where(:name => Setting.roles.role_grp_worker).first
@role_grp_sign_log  = Role.where(:name => Setting.roles.role_grp_sign_log).first

##厂区管理者
@fctmgn = [@role_fct, @role_worker, @role_device, @role_inspector, @role_sign_log]
#公司
#@cpy_mgn = [@role_cpy, @role_cpy_worker, @role_cpy_device, @role_cpy_inspector, @role_cpy_sign_log]
##集团管理者
@grp_mgn = [@role_grp, @role_grp_worker, @role_grp_device, @role_grp_inspector, @role_grp_sign_log]

@lssw = Company.create!(:area => "梁山县", :name => "中建六局")
@zouc = Company.create!(:area => "邹城市", :name => "青岛亿联建设")
@jiax = Company.create!(:area => "嘉祥县", :name => "中建生态")
@yanz = Company.create!(:area => "任城区", :name => "中铁市政")
#@wens = Company.create!(:area => "汶上县", :name => "汶上农污工程建设")
#@qufu = Company.create!(:area => "曲阜市", :name => "曲阜农污工程建设")
#@renc = Company.create!(:area => "任城区", :name => "任城农污工程建设")
#@beih = Company.create!(:area => "太白湖新区", :name => "北湖农污工程建设")
#@jinx = Company.create!(:area => "微山县", :name => "微山农污工程建设")

@lsswls  = Factory.create!(:area => "梁山县",     :name => "中建六局-梁山县",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
@lsswjx  = Factory.create!(:area => "嘉祥县",     :name => "中建六局-嘉祥县",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
@lsswjk  = Factory.create!(:area => "经济开发区",     :name => "中建六局-经济开发区",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
@lsswqf  = Factory.create!(:area => "曲阜市",     :name => "中建六局-曲阜市",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
@lsswss  = Factory.create!(:area => "泗水县",     :name => "中建六局-泗水县",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
@lsswws  = Factory.create!(:area => "微山县",     :name => "中建六局-微山县",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
@lsswzc  = Factory.create!(:area => "邹城市",     :name => "中建六局-邹城市",       :company => @lssw, :lnt => 116.131779, :lat => 35.765957, :design => 20000)
User.create!(:phone => "053701013708", :password => "lsnwgc0101", :password_confirmation => "lsnwgc0101", :name => "中建六局-梁山县",     :roles => @fctmgn,    :factories => [@lsswls])
User.create!(:phone => "053766883708", :password => "lsswjx6688", :password_confirmation => "lsswjx6688", :name => "中建六局-嘉祥县",     :roles => @fctmgn,    :factories => [@lsswjx])
User.create!(:phone => "053798983708", :password => "lsswjk3708", :password_confirmation => "lsswjk3708", :name => "中建六局-经济开发区",     :roles => @fctmgn,    :factories => [@lsswjk])
User.create!(:phone => "053769693708", :password => "lsswqf6969", :password_confirmation => "lsswqf6969", :name => "中建六局-曲阜市",     :roles => @fctmgn,    :factories => [@lsswqf])
User.create!(:phone => "053700009588", :password => "lsswss9588", :password_confirmation => "lsswss9588", :name => "中建六局-泗水县",     :roles => @fctmgn,    :factories => [@lsswss])
User.create!(:phone => "053799993708", :password => "lsswws9999", :password_confirmation => "lsswws9999", :name => "中建六局-微山县",     :roles => @fctmgn,    :factories => [@lsswws])
User.create!(:phone => "053712343708", :password => "lsswzc1234", :password_confirmation => "lsswzc1234", :name => "中建六局-邹城市",     :roles => @fctmgn,    :factories => [@lsswzc])


@zcswyz  = Factory.create!(:area => "兖州区",     :name => "青岛亿联建设-兖州区",       :company => @zouc, :lnt => 117.007406, :lat => 35.402536, :design => 80000)
@zcswyt  = Factory.create!(:area => "鱼台县",     :name => "青岛亿联建设-鱼台县",       :company => @zouc, :lnt => 117.007406, :lat => 35.402536, :design => 80000)
User.create!(:phone => "053709096688", :password => "zcnwgc0909", :password_confirmation => "zcnwgc0909", :name => "青岛亿联建设-兖州区",     :roles => @fctmgn,    :factories => [@zcswyz])
User.create!(:phone => "053758586688", :password => "wsnwgc5858", :password_confirmation => "wsnwgc5858", :name => "青岛亿联建设-鱼台县",     :roles => @fctmgn,    :factories => [@zcswyt])


@jxswrc  = Factory.create!(:area => "任城区",     :name => "中建生态-任城区",       :company => @jiax, :lnt => 116.342308, :lat => 35.40794, :design => 80000)
@jxswws  = Factory.create!(:area => "汶上县",     :name => "中建生态-汶上县",       :company => @jiax, :lnt => 116.342308, :lat => 35.40794, :design => 80000)
User.create!(:phone => "053745671111", :password => "jxnwgc4567", :password_confirmation => "jxnwgc4567", :name => "中建生态-任城区",     :roles => @fctmgn,    :factories => [@jxswrc])
User.create!(:phone => "053737089898", :password => "qfnwgc3708", :password_confirmation => "qfnwgc3708", :name => "中建生态-汶上县",     :roles => @fctmgn,    :factories => [@jxswws]) 


@yzswrc  = Factory.create!(:area => "任城区",     :name => "中铁市政-任城区",       :company => @yanz, :lnt => 116.78365, :lat => 35.551938, :design => 60000)
User.create!(:phone => "053701011818", :password => "yznwgc0101", :password_confirmation => "yznwgc0101", :name => "中铁市政管理者",     :roles => @fctmgn,    :factories => [@yzswrc])

#@wssw  = Factory.create!(:area => "汶上县",     :name => "汶上农污工程建设",       :company => @wens, :lnt => 116.497277, :lat => 35.711891, :design => 40000)
#@qfsw  = Factory.create!(:area => "曲阜市",     :name => "曲阜农污工程建设",       :company => @qufu, :lnt => 116.986212, :lat => 35.581933, :design => 40000)
#@rcws  = Factory.create!(:area => "任城区",     :name => "任城农污工程建设",     :company => @renc, :lnt => 116.605763, :lat => 35.444226, :design => 20000)
#@bhws  = Factory.create!(:area => "太白湖新区", :name => "北湖农污工程建设",     :company => @beih, :lnt => 116.595498, :lat => 35.349988, :design => 20000)
#@dsmt  = Factory.create!(:area => "微山县",     :name => "微山农污工程建设", :company => @jinx, :lnt => 117.129188,  :lat => 34.806657, :design => 20000)

#User.create!(:phone => "053799996688", :password => "rcnwgc9999", :password_confirmation => "rcnwgc9999", :name => "任城农污工程建设管理者",     :roles => @fctmgn,    :factories => [@rcws]) 
#User.create!(:phone => "053712346688", :password => "dsnwgc6688", :password_confirmation => "dsnwgc6688", :name => "微山农污工程建设管理者",     :roles => @fctmgn,    :factories => [@dsmt])


all_factories = Factory.all
user.factories << all_factories

#集团运营
#grp_opt = User.create!(:phone => "15763703588", :password => "swjt3588", :password_confirmation => "swjt3588", :name => "水务集团运营", :roles => @grp_opt, :factories => all_factories)

#集团管理
grp_mgn = User.create!(:phone => "05376688", :password => "swjt0537", :password_confirmation => "swjt0537", :name => "水务集团管理者", :roles => @grp_mgn, :factories => all_factories)
#注释结束

Deploy.create!(:name => 'weixin')

##分公司管理者
#@role_cpy = Role.where(:name => Setting.roles.role_cpy).first
#@cpy_mgn = [@role_cpy, @role_grp_worker, @role_grp_device, @role_grp_inspector, @role_grp_sign_log]
#
#@lsswjk  = Factory.find_by_name("中建六局-经济开发区")
#@lsswls  = Factory.find_by_name("中建六局-梁山县")
#@lsswjx  = Factory.find_by_name("中建六局-嘉祥县")
#@lsswqf  = Factory.find_by_name("建设集团-曲阜市")
#@lsswss  = Factory.find_by_name("中建六局-泗水县")
#@lsswws  = Factory.find_by_name("中建六局-微山县")
#@lsswzc  = Factory.find_by_name("中建六局-邹城市")
#User.create!(:phone => "158801013708", :password => "gynwgc0101", :password_confirmation => "gynwgc0101", :name => "水污染治理公司-梁山县",     :roles => @cpy_mgn,    :factories => [@lsswls])
#User.create!(:phone => "158866883708", :password => "gyswjx6688", :password_confirmation => "gyswjx6688", :name => "水污染治理公司-嘉祥县",     :roles => @cpy_mgn,    :factories => [@lsswjx])
#User.create!(:phone => "158898983708", :password => "gyswjk3708", :password_confirmation => "gyswjk3708", :name => "水污染治理公司-经济开发区",     :roles => @cpy_mgn,    :factories => [@lsswjk])
#User.create!(:phone => "158869693708", :password => "gyswqf6969", :password_confirmation => "gyswqf6969", :name => "水污染治理公司-曲阜市",     :roles => @cpy_mgn,    :factories => [@lsswqf])
#User.create!(:phone => "158800009588", :password => "gyswss9588", :password_confirmation => "gyswss9588", :name => "水污染治理公司-泗水县",     :roles => @cpy_mgn,    :factories => [@lsswss])
#User.create!(:phone => "158899993708", :password => "gyswws9999", :password_confirmation => "gyswws9999", :name => "水污染治理公司-微山县",     :roles => @cpy_mgn,    :factories => [@lsswws])
#User.create!(:phone => "158812343708", :password => "gyswzc1234", :password_confirmation => "gyswzc1234", :name => "水污染治理公司-邹城市",     :roles => @cpy_mgn,    :factories => [@lsswzc])
#
#@zcswyz  = Factory.find_by_name("青岛亿联建设-兖州区")
#@zcswyt  = Factory.find_by_name("青岛亿联建设-鱼台县")
#User.create!(:phone => "158809096688", :password => "yznwgc0909", :password_confirmation => "yznwgc0909", :name => "水污染治理公司-兖州区",     :roles => @cpy_mgn,    :factories => [@zcswyz])
#User.create!(:phone => "158858586688", :password => "wsnwgc5858", :password_confirmation => "wsnwgc5858", :name => "水污染治理公司-鱼台县",     :roles => @cpy_mgn,    :factories => [@zcswyt])
#
#@jxswrc  = Factory.find_by_name("中建生态-任城区")
#@jxswws  = Factory.find_by_name("中建生态-汶上县")
#User.create!(:phone => "158845671111", :password => "jxnwgc4567", :password_confirmation => "jxnwgc4567", :name => "水污染治理公司-任城区",     :roles => @cpy_mgn,    :factories => [@jxswrc])
#User.create!(:phone => "158837089898", :password => "qfnwgc3708", :password_confirmation => "qfnwgc3708", :name => "水污染治理公司-汶上县",     :roles => @cpy_mgn,    :factories => [@jxswws]) 
