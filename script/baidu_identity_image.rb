require 'restclient'
require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'json'
require 'yaml'
require 'fileutils'
require 'base64'
require 'find'

BASE_DIR = "/home/zn/work/website/public/" 
ROOT_DIR = BASE_DIR + "image_library" 
SUCCESS_DIR = BASE_DIR + "success_image_library"
FAIL_DIR = BASE_DIR + "fail_image_library"

MAX_TIMES = 2 
$time = 0

FileUtils.makedirs(FAIL_DIR) unless File.exists?FAIL_DIR

def process
  Dir.foreach(ROOT_DIR).each do |d|
    if $time >= MAX_TIMES
      break
    end
    if d != "." and d != ".."
      success_folder = SUCCESS_DIR + '/' + d
      FileUtils.makedirs(success_folder) unless File.exists?success_folder
      baidu_image_identity(ROOT_DIR + '/' + d, success_folder) 
    end
  end
end 

def baidu_image_identity(image_dir, target_dir) 
  url = "https://aip.baidubce.com/rest/2.0/image-classify/v2/advanced_general"
  access_token = "24.a9188da435b0e0b80ce4d8b7cc981a3d.2592000.1572611995.282335-16166275"
  content_type = "application/x-www-form-urlencoded"

  result = []
  Find.find(image_dir).each do |img|
    if img =~ /\.(?:jpg|png|jpeg)/i
      hash = Hash.new
      file = open(img).read
      image = Base64.encode64(file)
      RestClient.post(url, {access_token: access_token, image: image}, {content_type: content_type}) do |response|
        body = JSON.parse(response.body)
        puts body
        unless body['error_code'].nil?
          FileUtils.mv(img, FAIL_DIR)
        else
          root = ''
          keyword = ''
          body["result"].each do |obj|
            root += obj['root']
            keyword += obj['keyword']
          end
          hash['root'] = root
          hash['keyword'] = keyword
          result << hash
          FileUtils.mv(img, target_dir)
        end
      end
      $time = $time + 1
      if $time >= MAX_TIMES
        File.open('./result.yml', 'a+') do |f|
          YAML.dump(result, f)
        end
        break
      end
      sleep(rand(3))
    end
  end
end 

process
