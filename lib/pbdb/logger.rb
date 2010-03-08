module PBDB
  class Logger
    class << self
      def run
        Thread.start do
          begin
            loop do
              log
              sleep 10
            end
          rescue => e
            puts "#{e.message}\n#{e.backtrace.join("\n")}"
            exit!
          end
        end
      end

      def log
        # TODO: 
      end
    end
  end
end
