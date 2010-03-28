# -*- coding: utf-8 -*-

require "yaml"
require "sequel"

module PBDB
  DIR      = File.expand_path("~/.pbdb") unless defined? DIR
  CONF     = YAML.load_file(File.join(DIR, 'config'))
  PID_FILE = File.join(DIR, 'pid') # TODO: check config
  DB       = Sequel.sqlite(File.join(DIR, 'db'))

  require 'pbdb/logger'
  require 'pbdb/server'
  require 'pbdb/clip'

  class << self
    def start
      # TODO: deamonize
      puts "## PBDB has started ##"

      File.open(PID_FILE, 'w') { |f| f << Process.pid }

      PBDB::Logger.run!

      at_exit do
        PBDB::Logger.stop!
        puts "## PBDB has ended ##"
      end

      PBDB::Server.run!
    end

    def stop
      Process.kill(:INT, File.read(PID_FILE).to_i)
    end

    def restart
      stop
      start
    end

    def open
      system 'open http://localhost:4567/'
    end
  end
end
