require 'yaml'
require 'logger'

namespace 'db' do
  desc "update user number"
  task(:update_user_numbers => :environment) do
    users = User.all
    users.each do |u|
      str = [*'a'..'z',*'0'..'9',*'A'..'Z'].sample(10).join
      number = Time.now.to_i.to_s + str + "%04d" % [rand(10000)]
      u.update_attribute(:number, number)
    end
  end
end
