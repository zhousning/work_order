module BaiduFace

  #{"error_code"=>0, "error_msg"=>"SUCCESS", "log_id"=>563734290, "timestamp"=>1653545363, "cached"=>0, "result"=>{"face_token"=>"3369e2d959c1caa57df976eb0b6f0e3a", "location"=>{"left"=>2034.32, "top"=>1157.2, "width"=>165, "height"=>157, "rotation"=>0}}}
  def add_faces(id)
    @worker = Worker.find(id)
    url = 'https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/add'
    has_error = false
    error_msg = ''
    @worker.img.split(',').each do |img|
      image = File.join(Rails.root, 'public', img)
      file = image_to_base64(image)
      params = {
        image: file,
        image_type: 'BASE64',
        user_id: @worker.idno,
        user_info: @worker.name,
        group_id: Setting.systems.face_group,
      }
      body = baidu_request(url, params)
      if body['error_code'] != 0 && body['error_code'] != 223105
        has_error = true 
        error_msg += body['error_msg'] + ', '
      end
      sleep(3)
    end
    if !has_error
      @worker.completed
    else
      @worker.canceled
      @worker.update_attributes!(:desc => error_msg)
    end
  end

  def delete_user(id)
    @worker = Worker.find(id)
    @worker.deleting
    url = "https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/delete?access_token=" + ENV['ACCESS_TOKEN']
    has_error = false
    error_msg = ''
    params = {
      group_id: Setting.systems.face_group,
      user_id: @worker.idno,
    }
    body = baidu_request(url, params)
    if body['error_code'] != 0
      has_error = true 
      error_msg += body['error_msg'] + ', '
    end
    if has_error
      @worker.canceled
      @worker.update_attributes!(:desc => error_msg)
    else
      @worker.destroy
    end
    sleep(2)
  end

  def search_face(file)
    url = "https://aip.baidubce.com/rest/2.0/face/v3/search?access_token=" + ENV['ACCESS_TOKEN']
    params = {
      image: image_to_base64(file),
      image_type: 'BASE64',
      match_threshold: 80,
      quality_control: 'NORMAL',
      liveness_control: 'NORMAL',
      group_id_list: Setting.systems.face_group,
    }
    sleep(2)

    body = baidu_request(url, params)
    body
  end

  #使用worker的avatar
  def add_face_entity(id)
    @worker = Worker.find(id)
    url = 'https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/add'
    file = @worker.avatar_base
    params = {
      image: file,
      image_type: 'BASE64',
      user_id: @worker.number,
      user_info: @worker.name,
      group_id: Setting.systems.face_group,
    }
    body = baidu_request(url, params)
    puts body
  end

  private
    def image_to_base64(photo)
      tempfile = open(photo)
      image_base64 = Base64.encode64(File.read(tempfile)).gsub(/\s/, '')
      tempfile.close
      image_base64
    end

    def baidu_request(url, params)
      url = url + "?access_token=" + ENV['ACCESS_TOKEN']
      body = nil
      RestClient.post(url, params, {content_type: "application/json;charset=UTF-8"}) do |response|
        body = JSON.parse(response.body)
      end
      body
    end

end
