require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "422e34439c1ce11f71017e8ff08d3236f1c56dc8d7072ecec5cc7c1f57eedab8"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
ActiveSupport.on_load(:active_record) do
  extend Dragonfly::Model
  extend Dragonfly::Model::Validations
end
