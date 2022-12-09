# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( kindeditor.js )
Rails.application.config.assets.precompile += %w[ckeditor/config.js]

#Rails.application.config.assets.precompile += %w( highcharts/highcharts.js highcharts/highcharts-more.js )
#Rails.application.config.assets.precompile += %w( introjs.js moment.js moment/zh-cn.js bootstrap-datetimepicker.js cocoon.js )
Rails.application.config.assets.precompile += %w(bootstrap-datetimepicker.js cocoon.js *.eot, *.ttf, *.woff)
