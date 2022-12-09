class HardWorker
  #include Sidekiq::Worker

  def perform(color, id)
    content = BlockContent.find(id)
    #category = baidu_article_category(content.title, content.description) 
    #tag = baidu_article_tag(content.title, content.description)
    #str = category + " " + tag 
    #tag_str = str.split(/\s+/).uniq.join(",")
    #content.add_tag(tag_str)
    #images = ImageLibrary.search tag_str, fields: [:tag], match: :text_middle
    #image = images.blank? ? ImageLibrary.first : images[0] 
    image = ImageLibrary.all.sample(1) 
    content.add_image(image.file_name)
  end 

  private
    def baidu_article_category(title, content) 
      title = title.blank? ? "信息" : title
      result = ""
      url = "https://aip.baidubce.com/rpc/2.0/nlp/v1/topic?access_token=24.f55b9f1ec8df427f18698c8eabf55635.2592000.1571792914.282335-10508969"
      params = '{
        "title": "' + title + '",' + 
        '"content": "' + content + '"
      }'
      params.encode! "GBK", "UTF-8"
      res = RestClient::Request.execute(:method=> :post, :url=> url, :payload=> params, :content_type => "application/json; charset=GBK", :accept => :json)
      res.encode! "UTF-8", "GBK"
      obj = JSON.parse(res.body)
      unless obj["error_code"]
        obj["item"]["lv1_tag_list"].each do |lv1|
          result += lv1["tag"] + " "
        end
        obj["item"]["lv2_tag_list"].each do |lv2|
          result += lv2["tag"] + " "
        end
      end
      result
    end 

    def baidu_article_tag(title, content)
      title = title.blank? ? "信息" : title
      result = ""
      url = "https://aip.baidubce.com/rpc/2.0/nlp/v1/keyword?access_token=24.f55b9f1ec8df427f18698c8eabf55635.2592000.1571792914.282335-10508969"
      params = '{
        "title": "' + title + '",' + 
        '"content": "' + content + '"
      }'
      params.encode! "GBK", "UTF-8"
      res = RestClient::Request.execute(:method=> :post, :url=> url, :payload=> params, :content_type => "application/json; charset=GBK", :accept => :json)
      res.encode! "UTF-8", "GBK"
      obj = JSON.parse(res.body)
      unless obj["error_code"]
        obj["items"].each do |item|
          result += item["tag"] + " "
        end
      end
      result
    end 

end
