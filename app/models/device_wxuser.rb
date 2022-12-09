class DeviceWxuser < ActiveRecord::Base
  belongs_to :device
  belongs_to :wx_user
end
