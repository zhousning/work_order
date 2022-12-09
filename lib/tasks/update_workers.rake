require 'yaml'
require 'logger'
require 'find'

namespace 'db' do
  desc "update_workers"
  task(:update_workers => :environment) do
    Worker.all.each do |w|
      w.update_attribute('idfront', Setting.workers.worker)
    end
  end
end
