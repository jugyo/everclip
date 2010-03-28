# -*- coding: utf-8 -*-

require 'pb'

module PBDB
  class ClipLogger
    class << self
      def run!(options)
        interval = options[:interval]
        ignore_duplication = options[:ignore_duplication]

        @running = true

        Thread.start do
          begin
            while @running do
              clip!(ignore_duplication)
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

      def clip!(ignore_duplication)
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
