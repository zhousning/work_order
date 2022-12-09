class DeviceQrcodeWorker
  include Sidekiq::Worker

  def perform(id)
    @device = Device.find(id)
    @factory = @device.factory
    factory = idencode(@factory.id)
    id = idencode(@device.id)
    link = Rails.application.routes.url_helpers.info_factory_device_url(:host => Setting.systems.host, :factory_id => factory, :id => id)
    qr_code_img = RQRCode::QRCode.new(link).as_png(
      border_modules: 1,
      size: 630
    )

    base_path = File.join(Rails.root, "app", "assets", "images", "qrcodebase.png")
    base = ChunkyPNG::Image.from_file(base_path)
    base.compose!(qr_code_img, 225, 350)

    @log = Logger.new('log/deviceqrcodeerror.log')
    if @device.update_attributes!(:qrcode => base.to_string)
      qrcode = Dragonfly.app.remote_url_for(@device.qrcode_uid)
      qrcode = File.join(Rails.root, "public", qrcode)
      command = "convert #{qrcode} -fill white -font #{ENV['FONT']} -gravity north -pointsize 70 -annotate +0+160 #{@device.name} -fill black -pointsize 60 -annotate +0+1050 #{@factory.name} #{qrcode}"
      system(command)
    else
      @log.error @factory.name + " device id: " + @device.id + "-" + @device.name + ' qrcode update error'  
    end
  end 

  private
    def idencode(value)
      (value.to_i*99 + 4933)*3 
    end

end
