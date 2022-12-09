require 'yaml'
require 'fileutils'
require 'logger'

namespace 'db' do
  desc "export qrcode"
  task(:export_qrcode => :environment) do
    LOCAL_DIR = "/home/zn/work/warehouse/qrcodes/"
    factories = Factory.all
    factories.each do |f|
      f_name = f.name
      target_path = LOCAL_DIR + f_name
      FileUtils.makedirs(target_path) unless File.exists?target_path

      f.devices.each do |device|
        next if device.qrcode_uid.nil?
        qrcode = Dragonfly.app.remote_url_for(device.qrcode_uid)
        qrcode = File.join(Rails.root, "public", qrcode)
        device_idno = device.idno
        device_name = device.name
        device_pos  = device.pos

        file_name = target_path + '/' + device_idno + '-' + device_name + '-' + device_pos + ".png"
        FileUtils.cp(qrcode, file_name)
      end
    end
  end
end

