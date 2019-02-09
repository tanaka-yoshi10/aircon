require 'beebotte'
require 'dotenv/load'

def handle(message)
  data = JSON.parse(message)['data'].first
  room = data['room']
  action = data['action']

  mac_address = case room
                when 'living'
                  ENV['MAC_LIVING']
                when 'bedroom'
                  ENV['MAC_BEDROOM']
                when 'office'
                  ENV['MAC_OFFICE']
                end
  ip_address = rarp(mac_address)
  if action == 'on'
    send_data(ip_address, ENV['ON_MESSAGE'])
  else
    send_data(ip_address, ENV['OFF_MESSAGE'])
  end
end

def arp
  `arp -a`
end

def rarp(mac_address)
  extract_ip_address(arp, mac_address)
end

def extract_ip_address(arp_response, mac_address)
  arp_response.each_line do |line|
    if m = line.match(/.*\((?<ip>\S+)\) at #{mac_address}.*/)
      return m[:ip]
    end
  end
end

def send_data(ip_address, message)
  puts ip_address
  puts message
  uri = URI.parse("http://#{ip_address}/smart/")
  response = Net::HTTP.post(uri, message)
  puts response.body
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
