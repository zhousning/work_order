require 'find'
require 'fileutils'
require "mini_magick"


#ROOT_DIR = File.join("../public", "image_library") 
#TARGET_DIR = File.join("../public", "target_image_library") 
ROOT_DIR = '/media/zn/文件1/新建文件夹' 
TARGET_DIR = '/media/zn/商品2/jpgs图' 

def process
  arr = []
  i = 0
  Dir.foreach(ROOT_DIR) do |d|
    if d != "." and d != ".."
      arr[i] = i 
      arr[i] = Thread.new{ ergodic(ROOT_DIR + '/' + d, d) }
      i = i+1
    end
  end
  arr.each do |t|
    t.join
  end
end 

def ergodic(dir, new_folder)
  target_dir = TARGET_DIR + '/' + new_folder
  FileUtils.makedirs(target_dir) unless File.exists?target_dir
  Find.find(dir).each do |file|
    name = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    new_file = target_dir + '/' + name + '.jpg' 
    begin
      if file =~ /\.(?:png|bmp|jpg|tif|jpeg)/i
        image = MiniMagick::Image.open(file)
        MiniMagick::Tool::Convert.new do |convert|
          convert << file 
          convert << "-resize" << "1920" if image.width > 1920
          convert << new_file
        end
      end
    rescue
      next
    end
    sleep(rand(3))
  end
end

process
