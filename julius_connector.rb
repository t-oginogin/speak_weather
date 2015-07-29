require 'socket'

class JuliusConnector
  TIMEOUT_COUNT = 5

  def self.open
    count = 0

    socket = nil
    until socket
      begin
        socket = TCPSocket.open("localhost", 10500)
      rescue
        puts "Failed to connect Julius."
        sleep 2
        if count >= TIMEOUT_COUNT
          puts 'Timeout to connect. Exit.'
          return nil
        end
        count += 1
        puts "Retrying..."
        retry
      end
    end

    puts "Success to connect Julius."
    socket
  end
end
