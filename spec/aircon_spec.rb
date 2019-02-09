require_relative('../app.rb')

describe do
  specify {
    arp_response = <<~EOF
    ? (192.168.1.29) at <incomplete> on eth0
    ? (192.168.1.36) at 00:1d:c9:9a:26:99 [ether] on eth0
    ? (192.168.1.51) at 8c:85:90:ba:a5:35 [ether] on eth0
    ntt.setup (192.168.1.1) at 10:4b:46:d8:e1:42 [ether] on eth0
    ? (192.168.1.39) at 08:66:98:05:da:e3 [ether] on eth0
    ec2-54-221-205-80.compute-1.amazonaws.com (54.221.205.80) at <incomplete> on eth0
    ? (192.168.1.55) at 48:65:ee:1a:0f:7e [ether] on eth0
    ? (192.168.1.25) at 18:31:bf:db:18:c5 [ether] on eth0
    ? (192.168.1.32) at 40:b3:95:a0:52:e0 [ether] on eth0
    ? (192.168.1.40) at 3c:2e:f9:c0:8a:f8 [ether] on eth0
    ? (192.168.1.21) at 00:1d:c9:9a:30:90 [ether] on eth0
    ? (192.168.1.34) at 00:1d:c9:9a:30:c2 [ether] on eth0
    EOF
    expect(extract_ip_address(arp_response, '00:1d:c9:9a:30:c2')).to eq '192.168.1.34'
    expect(extract_ip_address(arp_response, '00:1d:c9:9a:26:99')).to eq '192.168.1.36'
    expect(extract_ip_address(arp_response, '48:65:ee:1a:0f:7e')).to eq '192.168.1.55'
  }
end
