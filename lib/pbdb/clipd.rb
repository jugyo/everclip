# -*- coding: utf-8 -*-

require 'pb'

module PBDB
  class Clipd
    class << self
      attr_accessor :interval
      attr_accessor :ignore_duplication

      def run!
        @running = true
        interval ||= 2
        ignore_duplication ||= 60 * 60

        Thread.start do
          begin
            while @running do
              clip!
              sleep interval
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

      def clip!
        text = PB.read
        return if Clip.stored?(text, ignore_duplication)
        Clip << text
        puts <<EOS
## clip -------
#{text}
------------
EOS
      end
    end
  end
end
