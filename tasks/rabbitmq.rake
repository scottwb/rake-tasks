RABBITMQ_VERSION  = "2.8.6"
RABBITMQ_SRC_URL  = "http://www.rabbitmq.com/releases/rabbitmq-server/v#{RABBITMQ_VERSION}/rabbitmq-server-generic-unix-#{RABBITMQ_VERSION}.tar.gz"
RABBITMQ_SRC_FILE = RABBITMQ_SRC_URL.split('/').last
RABBITMQ_BIN_DIR  = File.expand_path("~/bin")
RABBITMQ_SBIN_DIR = File.join(RABBITMQ_BIN_DIR, "rabbitmq_server-#{RABBITMQ_VERSION}/sbin")

def rabbitmq_is_running?
  is_running = false
  Dir.chdir(RABBITMQ_SBIN_DIR) do
    is_running = run_with_erlang "./rabbitmqctl status > /dev/null 2>&1"
  end
  is_running
end

namespace :rabbitmq do
  desc "Install RabbitMQ v#{RABBITMQ_VERSION}"
  task :install => "erlang:install" do
    if File.directory? RABBITMQ_SBIN_DIR
      puts "RabbitMQ v#{RABBITMQ_VERSION} is already installed"
    else
      puts "Installing RabbitMQ v#{RABBITMQ_VERSION}..."
      mkdir RABBITMQ_BIN_DIR unless File.directory? RABBITMQ_BIN_DIR
      Dir.chdir(RABBITMQ_BIN_DIR) do
        sh "curl -O #{RABBITMQ_SRC_URL}"
        sh "tar -zxvf #{RABBITMQ_SRC_FILE}"
        rm RABBITMQ_SRC_FILE
      end
      Dir.chdir(RABBITMQ_SBIN_DIR) do
        run_with_erlang "./rabbitmq-plugins enable rabbitmq_management"
      end
    end
  end

  desc "Start RabbitMQ Server"
  task :start => :install do
    Dir.chdir(RABBITMQ_SBIN_DIR) do
      if rabbitmq_is_running?
        puts "RabbitMQ is already running"
      else
        run_with_erlang "./rabbitmq-server -detached"
      end
    end
  end

  desc "Stop RabbitMQ Server"
  task :stop do
    Dir.chdir(RABBITMQ_SBIN_DIR) do
      if rabbitmq_is_running?
        run_with_erlang "./rabbitmqctl stop"
      else
        puts "RabbitMQ is not running"
      end
    end
  end

  desc "Get RabbitMQ Server status"
  task :status do
    puts "RabbitMQ is#{rabbitmq_is_running? ? '' : ' not'} running"
  end

  desc "Open RabbitMQ Console"
  task :console => :start do
    sh "open http://localhost:55672/"
  end
end
