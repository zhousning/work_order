class Device < ActiveRecord::Base

  dragonfly_accessor :qrcode do
    storage_options :opts_for_storage
  end

  def opts_for_storage
    path = '/devices/fct' + self.factory.id.to_s + '/' + self.id.to_s
    { path: path}
  end

  mount_uploader :avatar, EnclosureUploader

  has_many :device_wxusers, :dependent => :destroy
  has_many :wx_users, :through => :device_wxusers

  belongs_to :factory

  #不在这里使用异步会出问题做个警示
  #after_commit :set_qrcode
  #def set_qrcode
  #  puts ' 1 model device'
  #  #DeviceQrcodeWorker.perform_async(self.id)
  #end

end
