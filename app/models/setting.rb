require 'yaml/store'

class Setting < Settingslogic
  PATH = "#{Rails.root}/config/config.yml"
  source PATH 
  namespace Rails.env

  def self.save(key, value)
    store = YAML::Store.new PATH
    store.transaction do
      store[Rails.env][key] = value.to_hash
    end
  end
end
