require 'mqtt'

MQTT::Client.connect('api.beebotte.com') do |c|
  # If you pass a block to the get method, then it will loop
  c.get('IrSignal/irSignal') do |topic,message|
    puts "#{topic}: #{message}"
  end
end
