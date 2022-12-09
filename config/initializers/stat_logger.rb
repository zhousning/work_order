stat_logfile = File.open("#{Rails.root}/log/statistics.log", 'a')
stat_logfile.sync = true
STAT_LOGGER = StatLogger.new(stat_logfile)
