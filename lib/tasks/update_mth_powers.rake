require 'yaml'
require 'logger'
require 'find'

namespace 'db' do
  desc "update_mth_powers"
  task(:update_mth_powers => :environment) do
    include FormulaLib
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @update_power_log = Logger.new(@log_dir + '更新电本月止数据错误.log')

    factories = Factory.all
    years = [2019, 2020, 2021]
    factories.each do |factory|
      years.each do |year|
        power_sum = 0
        12.times.each do |t|
          month = t + 1
          rpt = factory.mth_pdt_rpts.where(:start_date => Date.new(year, month, 1)).first
          if rpt
            mth_power = rpt.month_power
            power_sum = power_sum + mth_power.power
            unless mth_power.update_attributes(:end_power => power_sum)
              @update_power_log.error rpt.name + "本月止电数据更新失败"
            end
          end
        end
      end
    end
  end
end
