class BaiduFaceWorker
  include Sidekiq::Worker

  def perform(worker_id)
    @worker = Worker.find(worker_id)
    url = 'https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/add'
    has_error = false
    error_msg = ''
    @worker.img.split(',').each do |img|
      image = File.join(Rails.root, 'public', img)
      file = image_2_base64(image)
      params = {
        image: file,
        image_type: 'BASE64',
        user_id: @worker.idno,
        user_info: @worker.name,
        group_id: Setting.systems.face_group,
      }
      sleep(2)
      body = request_baidu(url, params)
      if body['error_code'] != 0 && body['error_code'] != 223105
        has_error = true 
        error_msg += body['error_msg'] + ', '
      end
    end
    if !has_error
      @worker.completed
    else
      @worker.canceled
      @worker.update_attributes!(:desc => error_msg)
    end
  end

  private
    def image_2_base64(photo)
      tempfile = open(photo)
      image_base64 = Base64.encode64(File.read(tempfile)).gsub(/\s/, '')
      tempfile.close
      image_base64
    end

    def request_baidu(url, params)
      url = url + "?access_token=" + ENV['ACCESS_TOKEN']
      body = nil
      RestClient.post(url, params, {content_type: "application/json;charset=UTF-8"}) do |response|
        body = JSON.parse(response.body)
      end
      body
    end

end
