require 'yaml'
require 'logger'

namespace 'db' do
  desc "user meter standard"
  task(:user_meter_standard => :environment) do
    init_user_meter_standard
  end
end

def init_user_meter_standard
  users = User.all
  users.each do |user|
    MeterStandard.create!(:user => user)
  end
end
