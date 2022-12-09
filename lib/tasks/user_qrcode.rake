require 'yaml'
require 'logger'

namespace 'db' do
  desc "user qrcode"
  task(:user_qrcode => :environment) do
    init 
  end
end

def init
  users = User.all
  users.each do |user|
    invite_link = Rails.application.routes.url_helpers.new_user_registration_url(:host => Setting.systems.host, :inviter=>user.number)
    qr_code_img = RQRCode::QRCode.new(invite_link).to_img.resize(300, 300)
    user.update(:qr_code => qr_code_img.to_string)
  end
end
