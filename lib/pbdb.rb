# -*- coding: utf-8 -*-

require "yaml"
require "sequel"

module PBDB
  PID_FILE = "/tmp/pbdb_pid"

  class << self
    attr_reader :dir, :db

    def init(dir)
      @dir = File.expand_path(dir || "~/.pbdb")
      @db = Sequel.sqlite(File.join(@dir, 'db'))
      require 'pbdb/clip'
      require 'pbdb/clip_logger'
      require 'pbdb/server'
    end

    def config
      unless File.exists?(config_file_path)
        File.open(config_file_path, 'w') do |f|
          f.write <<EOS
:host: localhost
:port: 5678
:interval: 2
:ignore_duplication: 60
EOS
        end
      end

      system(ENV["EDITOR"] || 'vi', config_file_path)
    end

    # TODO: deamonize
    def start
      if File.exists?(PID_FILE)
        puts "already running!"
        exit!
      end

      config = YAML.load_file(config_file_path)
      config = {} unless config.is_a?(Hash)

      PBDB::ClipLogger.run!(
        :interval => config[:interval] || 2,
        :ignore_duplication => config[:ignore_duplication] || 60 * 60
      )

      at_exit do
        PBDB::ClipLogger.stop!
        remove_pid_file
        puts "## PBDB has ended ##"
      end

      puts "## PBDB has started ##"

      PBDB::Server.run!(
        :Host => config[:host] || 'localhost',
        :Port => config[:port] || 4567
      )

      File.open(PID_FILE, 'w') { |f| f << Process.pid }
    end

    def stop
      return unless File.exists?(PID_FILE)
      Process.kill(:INT, File.read(PID_FILE).to_i)
    rescue Exception => e
      puts e.message
    ensure
      remove_pid_file
    end

    def restart
      stop
      start
    end

    def open
      system 'open http://localhost:4567/'
    end

    def config_file_path
      File.join(@dir, 'config')
    end

    def remove_pid_file
      File.delete(PID_FILE) if File.exists?(PID_FILE)
    end
  end
end
