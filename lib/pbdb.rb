# -*- coding: utf-8 -*-

require "yaml"

require 'pbdb/logger'
require 'pbdb/server'

module PBDB
  DIR = File.expand_path("~/.pbdb")
  CONF = YAML.load_file(File.join(DIR, 'config'))
  # TODO: check config
  PID_FILE = File.join(DIR, 'pid')

  class << self
    def start
      # TODO: deamonize
      puts "## PBDB has started ##"

      File.open(PID_FILE, 'w') { |f| f << Process.pid }

      at_exit do
        PBDB::Logger.stop!
        puts "## PBDB has ended ##"
      end

      PBDB::Logger.run!
      PBDB::Server.run!
    end

    def stop
      Process.kill(:INT, File.read(PID_FILE).to_i)
    end

    def restart
      stop
      start
    end
  end
end
