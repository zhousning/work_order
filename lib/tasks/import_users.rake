require 'yaml'
require 'logger'

namespace 'db' do
  desc "init user"
  task(:import_users => :environment) do
    init_import
  end
end

def init_import
  
  excelTool = ExcelTool.new
  lsswxls = excelTool.parseExcel("lib/tasks/data/lsswusers.xlsx") 
  users = lsswxls["Sheet1"]
  users.each_with_index do |user, index|
    name = user["B" + (index+1).to_s]
    identity = user["H" + (index+1).to_s]
    user_name = name.gsub(/\s/, "") 
    user_identity = identity.gsub(/\s/, "") 
    password = "lssw" + user_identity[6..13]
    User.create(:name => user_name, :phone => user_identity, :identity => user_identity, :password => password, :password_confirmation => password)
  end
  #users.each do |user|
  #  p_phone = user[0].to_s
  #  unless user_hash[p_phone]
  #    @parent = User.create(:phone => p_phone, :password => "123456", :password_confirmation => "123456")
  #  end
  #end
end
