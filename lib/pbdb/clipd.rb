# -*- coding: utf-8 -*-

require 'pb'

module PBDB
  class Clipd
    class << self

      def run!
        @running = true

        Thread.start do
          begin
            while @running do
              clip!
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

      def clip!
        text = PB.read
        return if Clip.stored?(text, 60 * 60)
        Clip << text
        puts <<EOS
## clip -------
#{text}
## ------------
EOS
      end
    end
  end
end
