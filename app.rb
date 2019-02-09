require 'beebotte'
require 'dotenv/load'

def handle(message)

end

def rarp(mac_address)

end

def extract_ip_address(arp_response, mac_address)
  arp_response.each_line do |line|
    if m = line.match(/.*\((?<ip>\S+)\) at #{mac_address}.*/)
      return m[:ip]
    end
  end
end

def send_data(ip_address, message)

end

if $0 == __FILE__
  s = Beebotte::Stream.new({token: ENV['CHANNEL_TOKEN']})
  s.connect()
  s.subscribe("#{ENV['CHANNEL_NAME']}/#{ENV['RESOURCE_NAME']}")
  s.get do |topic, message|
    puts "Topic: #{topic}\nMessage: #{message}"
    handle(message)
  end
end
