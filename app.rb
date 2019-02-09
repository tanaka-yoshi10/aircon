require 'beebotte'
require 'dotenv/load'

def handle(data)

end

def rarp(mac_address)

end

def send_data(ip_address, message)

end

s = Beebotte::Stream.new({token: ENV['CHANNEL_TOKEN']})
s.connect()
s.subscribe("#{ENV['CHANNEL_NAME']}/#{ENV['RESOURCE_NAME']}")
s.get { |topic, message|
  puts "Topic: #{topic}\nMessage: #{message}"
}
