ERLANG_VERSION      = "R15B01"
ERLANG_BUILD_NAME   = ERLANG_VERSION.downcase
ERLANG_BIN_DIR      = File.expand_path("~/bin/erlang")
ERLANG_PATH         = File.join(ERLANG_BIN_DIR, ERLANG_BUILD_NAME)

def erlang_is_built?
  system "kerl list builds | grep #{ERLANG_VERSION} > /dev/null"
end

def erlang_is_installed?
  system "kerl list installations | grep #{ERLANG_BUILD_NAME} > /dev/null"
end

def run_with_erlang(cmd)
  system ". #{ERLANG_PATH}/activate && #{cmd}"
end

namespace :erlang do
  desc "Build Erlang #{ERLANG_VERSION}"
  task :build => "kerl:install" do
    if erlang_is_built?
      puts "Erlang #{ERLANG_VERSION} is already built"
    else
      puts "Building Erlang #{ERLANG_VERSION}..."
      sh "kerl build #{ERLANG_VERSION} #{ERLANG_BUILD_NAME}"
    end
  end

  desc "Install Erlang #{ERLANG_VERSION} to #{ERLANG_PATH}"
  task :install => :build do
    if erlang_is_installed?
      puts "Erlang #{ERLANG_VERSION} is already installed"
    else
      mkdir ERLANG_BIN_DIR unless File.directory? ERLANG_BIN_DIR
      puts "Installing Erlang #{ERLANG_VERSION} to #{ERLANG_PATH}..."
      sh "kerl install #{ERLANG_BUILD_NAME} #{ERLANG_PATH}"
    end
  end
end
