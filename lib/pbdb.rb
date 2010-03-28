# -*- coding: utf-8 -*-

require "yaml"
require "sequel"

module PBDB
  DIR      = File.expand_path("~/.pbdb") unless defined? DIR
  CONFIG   = YAML.load_file(File.join(DIR, 'config')) # TODO: check config
  PID_FILE = File.join(DIR, 'pid')
  DB       = Sequel.sqlite(File.join(DIR, 'db'))

  require 'pbdb/clip'
  require 'pbdb/clip_logger'
  require 'pbdb/server'

  class << self
    def start
      # TODO: deamonize
      puts "## PBDB has started ##"

      File.open(PID_FILE, 'w') { |f| f << Process.pid }

      at_exit do
        PBDB::ClipLogger.stop!
        puts "## PBDB has ended ##"
      end

      PBDB::ClipLogger.run!(
        :interval => CONFIG[:interval] || 2,
        :ignore_duplication => CONFIG[:ignore_duplication] || 60 * 60
      )
      PBDB::Server.run!(
        :Host => CONFIG[:host] || 'localhost',
        :Port => CONFIG[:port] || 4567
      )
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
