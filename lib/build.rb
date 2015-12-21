# build.rb
# Contains functions to provision tubs

require "yaml"
require_relative "logger"
require_relative "help"
require_relative "error"
require_relative "set"
require_relative "build_class"
# TODO: Uncomment lin below for production
# home = ENV["HOME"] || ENV["HOMEPATH"]

def build(args, worker, app, dir)
  # Load config
  home = ENV["PWD"]
  config = YAML.load_file("#{dir}/.boss.yml")
  tub = YAML.load_file("#{home}/boss/tub_config.yml")
  # See what to do
  build = Runner::Builder.new()
  # Create .boss dir
  require 'fileutils'
  FileUtils.mkdir_p "#{dir}/.boss"
  # Create file and append shebang
  @shebang = "#!/bin/bash\n"
  bui = File.open "#{dir}/.boss/build.sh","w+"
  bui.write @shebang

  if config["language"] == "nodejs"
    # Provision box
    log("Provisioning tub...")
    log("Packages to install:")
    log("   nodejs:  #{tub["version"]}")
    config["require"].each do |c|
      log("     #{c}:  latest")
    end
    # Add nvm install
    log("Installing required nodejs version...")
    bui.write "echo Installing required nodejs version...\n"
    @nvm = ". ~/.nvm/nvm.sh"
    bui.write "#{@nvm}\n"
    @ninstall = "nvm install #{tub["version"]}"
    bui.write "echo '#{@ninstall}'\n#{@ninstall}\n"
    log("`nvm install #{tub["version"]}`")
    `#{ninstall}`
  end
end
