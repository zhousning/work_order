require 'yaml'
require 'logger'

namespace 'db' do
  desc "update user"
  task(:update_users => :environment) do
    init_update 
  end
end

def init_update
  users = YAML.load_file("lib/tasks/user.yaml")
  
  users.each do |user|
    p_phone = user[0].to_s
    @parent = User.find_by_phone(p_phone)
    if !@parent
      @parent = User.create(:phone => p_phone, :password => "123456", :password_confirmation => "123456")
    end
  
    if !user[1].nil?
      user[1].each do |c|
        c_phone = c.to_s
        @child = User.find_by_phone(c_phone)
        if !@child
          @child = User.create(:phone => c_phone, :password => "123456", :password_confirmation => "123456", :parent_id => @parent.id, :inviter => @parent.number)
        else
          @child.update(:parent => @parent)
        end
      end
    end
  end
end
