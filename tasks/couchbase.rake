COUCHBASE_VERSION   = "2.1.1"
COUCHBASE_SRC_URL   = "http://packages.couchbase.com/releases/#{COUCHBASE_VERSION}/couchbase-server-community_x86_64_#{COUCHBASE_VERSION}.zip"
COUCHBASE_SRC_FILE  = COUCHBASE_SRC_URL.split('/').last
COUCHBASE_BIN_PATH  = "/Applications/Couchbase Server.app"
COUCHBASE_DATA_PATH = "#{ENV['HOME']}/Library/Application Support/Couchbase"

namespace :couchbase do
  desc "Install Couchbase v#{COUCHBASE_VERSION}"
  task :install do
    if File.exists? COUCHBASE_BIN_PATH
      puts "Couchbase is already installed"
    else
      puts "Installing Couchbase v#{COUCHBASE_VERSION}..."
      sh "curl -O #{COUCHBASE_SRC_URL}"
      sh "unzip #{COUCHBASE_SRC_FILE}"
      rm COUCHBASE_SRC_FILE
      rm "README.txt" # Unzipped from couchbase
      mv "Couchbase Server.app", COUCHBASE_BIN_PATH
    end
  end

  desc "Uninstall Couchbase and remove all its data"
  task :uninstall do
    puts "Removing Couchbase installation..."
    rm_rf COUCHBASE_BIN_PATH
    puts "Removing Couchbase data..."
    rm_rf COUCHBASE_DATA_PATH
  end

  desc "Start Couchbase Server"
  task :start => :install do
    sh "open '#{COUCHBASE_BIN_PATH}'"
  end

  desc "Stop Couchbase Server"
  task :stop do
    puts "Stop Couchbase by using the taskbar menu."
  end

  desc "Get Couchbase Server status"
  task :status do
    puts "Check Couchbase status via the taskbar menu."
  end

  desc "Open Couchbase Console"
  task :console => :start do
    sh "open http://localhost:8091/"
  end
end
