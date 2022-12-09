Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0'  }
  #如果有定时任务就删除以下注释,没有就不要打开不然会出错
  #schedule_file = "config/schedule.yml"
  #if File.exists?(schedule_file) && Sidekiq.server?
  #  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  #end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0'  }
end
