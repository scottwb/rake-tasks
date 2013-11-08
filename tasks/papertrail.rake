PAPERTRAIL_CONFIG = File.expand_path("../../config/remote_syslog.yml", __FILE__)
PAPERTRAIL_PID    = File.expand_path("../../tmp/pids/remote_syslog.pid", __FILE__)

namespace :papertrail do

  def papertrail_is_running?
    File.exists?(PAPERTRAIL_PID) && system("ps x | grep `cat #{PAPERTRAIL_PID}` 2>&1 > /dev/null")
  end

  desc "Start papertrail remote_syslog daemon."
  task :start => :stop do
    if papertrail_is_running?
      puts "Papertrail is already running."
    else
      sh "remote_syslog -c #{PAPERTRAIL_CONFIG} --pid-file #{PAPERTRAIL_PID}"
    end
  end

  desc "Stop papertrail remote_syslog daemon."
  task :stop do
    if File.exists? PAPERTRAIL_PID
      sh "kill `cat #{PAPERTRAIL_PID}`"
      rm_f PAPERTRAIL_PID
    end
  end

  desc "Show status of papertrail remote_syslog daemon."
  task :status do
    if papertrail_is_running?
      puts "Papertrail remote_syslog is running"
    else
      puts "Papertrail remote_syslog is stopped"
    end
  end
end
