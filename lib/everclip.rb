# -*- coding: utf-8 -*-

require "yaml"
require "sequel"

module EverClip
  PID_FILE = "/tmp/everclip_pid"

  class << self
    attr_reader :dir, :db

    def init(dir = nil)
      @dir = File.expand_path(dir || "~/.everclip")
      @db = Sequel.sqlite(File.join(@dir, 'db'))
      require 'everclip/clip'
      require 'everclip/clip_logger'
      require 'everclip/server'
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

      EverClip::ClipLogger.run!(
        :interval => config[:interval] || 2,
        :ignore_duplication => config[:ignore_duplication] || 60 * 60
      )

      at_exit do
        EverClip::ClipLogger.stop!
        remove_pid_file
        puts "## EverClip has ended ##"
      end

      puts "## EverClip has started ##"

      EverClip::Server.run!(
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
