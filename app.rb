require 'beebotte'
require 'dotenv/load'
require 'open-uri'
require 'nokogiri'

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
  puts mac_address
  ip_address = rarp(mac_address)
  if action == 'on'
    send_data(ip_address, ENV['ON_MESSAGE'])
  else
    send_data(ip_address, ENV['OFF_MESSAGE'])
  end
end

def rarp(mac_address)
  certs = [ENV['BASIC_USER'], ENV['BASIC_PASSWORD']]
  charset = nil
  url = ENV['DHCP_SERVER_URL']

  html = open(url, {:http_basic_authentication => certs}) do |f|
    charset = f.charset
    f.read
  end
  extract_ip_address(html, mac_address, charset)
end

def extract_ip_address(html, mac_address, charset)
  doc = Nokogiri::HTML.parse(html, nil, charset)
  trs = doc.xpath('//table[@class="data"]//tbody//tr')
  tr = trs.find do |tr|
    tr.search("td[2]").text.strip == mac_address
  end

  if tr
    tr.search("td[1]").text.split('/').first
  else
    nil
  end
end

def send_data(ip_address, message)
  puts ip_address
  puts message
  return if ip_address.nil?
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
