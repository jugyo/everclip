# -*- coding: utf-8 -*-

require "yaml"
require "sequel"
require "fileutils"

module EverClip
  class << self
    attr_reader :dir, :db, :config

    # TODO: deamonize
    def start
      puts "## EverClip has started ##"

      setup_dir
      load_config
      setup_db

      require 'everclip/clip'
      require 'everclip/clip_logger'
      require 'everclip/server'

      start_clip_logger
      setup_at_exit
      start_server
    end

    def open
      system 'open http://localhost:4567/'
    end

    def setup_dir
      return if dir
      @dir = File.expand_path("~/.everclip")
      unless File.exists?(@dir)
        FileUtils.mkdir_p(@dir)
        puts ">> mkdir #{@dir}"
      end
    end

    def setup_db
      @db = Sequel.sqlite(File.join(@dir, 'db'))
    end

    def load_config
      unless File.exists?(config_file_path)
        create_default_config
        puts ">> default config file was created."
      end
      puts ">> load config: #{config_file_path}"
      config = YAML.load_file(config_file_path)
      config = {} unless config.is_a?(Hash)
      @config = config
      puts ">> config: #{config.inspect}"
    end

    def create_default_config
      File.open(config_file_path, 'w') do |f|
        f.write <<EOS
:host: localhost
:port: 5678
:interval: 2
:ignore_duplication: 60
EOS
      end
    end

    def config_file_path
      File.join(dir, 'config')
    end

    def start_server
      EverClip::Server.run!(
        :Host => config[:host] || 'localhost',
        :Port => config[:port] || 4567
      )
    end

    def start_clip_logger
      EverClip::ClipLogger.run!(
        :interval => config[:interval] || 2,
        :ignore_duplication => config[:ignore_duplication] || 60 * 60
      )
    end

    def setup_at_exit
      at_exit do
        EverClip::ClipLogger.stop!
        puts "## EverClip has ended ##"
      end
    end
  end
end
