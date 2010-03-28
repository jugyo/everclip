# -*- coding: utf-8 -*-

require 'pb'
require 'digest/sha1'

module PBDB
  class Logger
    class << self

      def run!
        @running = true

        Thread.start do
          begin
            while @running do
              log
              sleep 10
            end
            puts "has ended"
          rescue => e
            puts "#{e.message}\n#{e.backtrace.join("\n")}"
            exit!
          end
        end
      end

      def stop!
        @running = false
      end

      def log
        text = PB.read
        sha1 = Digest::SHA1.hexdigest(text)
        return if sha1 == @last_clip_sha1

        @last_clip_sha1 = sha1
        # TODO: store clipboard text
        puts <<EOS
## clip -------
#{text}
## ------------
EOS
      end
    end
  end
end
