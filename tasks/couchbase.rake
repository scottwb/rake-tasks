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

  desc "Backs up the Couchbase data."
  task :backup, [:username,:password] do |t, args|
    username = args[:username]
    password = args[:password]
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    dirname   = "#{timestamp}-couchbase"
    mkdir dirname
    puts "Backing up data..."
    sh "\"#{COUCHBASE_BIN_PATH}/Contents/Resources/couchbase-core/bin/cbbackup\" http://127.0.0.1:8091 #{dirname} -u \"#{username}\" -p \"#{password}\""
    puts "Archiving backup..."
    sh "tar -cjvf #{dirname}.tar.bz2 #{dirname}"
    puts "Removing temp files..."
    rm_rf dirname
    puts "Done."
    puts
    puts "Backed up Couchbase to: #{dirname}.tar.bz2"
    puts
  end

  desc "Restore Couchbase data from backup. Requires all buckets to be already created."
  task :restore, [:backup_filepath,:username,:password] do |t, args|
    tarname = args[:backup_filepath]
    username = args[:username]
    password = args[:password]
    dirname = File.basename(tarname).split('.').first
    puts "Unpacking archive..."
    sh "tar -jxvf #{tarname}"
    puts "Restoring data..."
    sh "\"#{COUCHBASE_BIN_PATH}/Contents/Resources/couchbase-core/bin/cbrestore\" -u \"#{username}\" -p \"#{password}\" #{dirname} couchbase://127.0.0.1:8091"
    puts "Removing temp files..."
    rm_rf dirname
    puts "Done."
  end
end
