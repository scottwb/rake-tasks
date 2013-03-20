KERL_BIN_DIR = File.expand_path("~/bin")
KERL_PATH    = File.join(KERL_BIN_DIR, 'kerl')
KERLRC_PATH  = File.expand_path("~/.kerlrc")
KERL_SRC_URL = "https://raw.github.com/spawngrid/kerl/master/kerl"

namespace :kerl do
  desc "Install kerl to install and manage Erlang versions"
  task :install do
    mkdir KERL_BIN_DIR unless File.directory? KERL_BIN_DIR
    if File.exists? KERL_PATH
      puts "kerl is already installed"
    else
      Dir.chdir(KERL_BIN_DIR) do
        sh "curl -O #{KERL_SRC_URL}"
        sh "chmod a+x kerl"
      end

      if `uname` =~ /Darwin/
        unless File.exists? KERLRC_PATH
          File.open(KERLRC_PATH, "wb") do |f|
            f << 'KERL_CONFIGURE_OPTIONS="--disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit"'
          end
        end
      end
    end
  end
end
