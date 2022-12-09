class IdentityImage 
  ROOT_DIR = File.join(Rails.root, "public", "image_library") 
  def perform
    Find.find(ROOT_DIR).each do |img|
      baidu_image_identity(img) if File.file?(img)
    end
  end 

  private
    def baidu_image_identity(image_src) 
      url = "https://aip.baidubce.com/rest/2.0/image-classify/v2/advanced_general"
      access_token = "24.f55b9f1ec8df427f18698c8eabf55635.2592000.1571792914.282335-10508969"
      content_type = "application/x-www-form-urlencoded"

      file = open(image_src).read
      image = Base64.encode64(file)

      #RestClient.post(url, {access_token: access_token, image: image}, {content_type: content_type}) do |response|
      #body = JSON.parse(response.body)
      #return raise unless body['error_code'].nil?
      #return body["words_result"][0]["words"]
      #body["result"].each do |obj|
      #  puts obj['root']
      #end
    end 
end
