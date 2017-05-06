Exercise 3 - Inbound Web Traffic - Blocking Malicious Domains

Overview

Squid is an open source web proxy server that monitors and blocks web (HTTP) traffic. While it typically monitors outbound (client) traffic, it can be configured in reverse proxy mode to filter inbound traffic destined to a web server. We'll be using Squid in this reverse proxy mode to monitor and block traffic.

Goals

  * Monitor inbound web (HTTP) traffic from the client to web
  * Enable Squid as a reverse proxy in front of the web server
  * Block web traffic from the client to the web using 
  * Utilize service chains to manipulate the packet flows

Image login info:

  * admin/openstack for the CirrosWeb image
  * admin/openstack for the NetMon image
  
Tools

  * NetMon image is equipped with Snort and TCPDump
  * TCPDump usage information: http://www.tcpdump.org/tcpdump_man.html
  * Snort usage information: http://www.manpagez.com/man/8/snort/
  * Configuring Squid in Transparent mode: http://www.dd-wrt.com/wiki/index.php/Squid_Transparent_Proxy

Prereq
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * Setup the external and internal networking

Instances

Startup the following three images and assign floating IPs to all.

| Instance Name | Image         | Flavor   | Network  | Floating IP |
| ------------- |:-------------:| --------:|---------:|------------:|
| Client        | CirrosWeb     | m1.tiny  | internal |  assign     |
| WebServer     | CirrosWeb     | m1.tiny  | internal |  assign     |
| NetMon-1      | NetMon        | m1.small | internal |  assign     |
| NetMon-2      | NetMon        | m1.small | internal |  assign     |

Startup the web server on the WebServer virtual machine.

(on WebServer)
$ sudo su -
# ./hostname-webserver.sh

Verify that the client can connect to the Web. Replace 'X' with the private IP of the WebServer.

(on Client)
$ curl http://192.168.100.X

Add in the service chain

Configure Squid on the NetMon

Set the following in the Squid configuration:
http_port 192.168.1.X:80 transparent
Substituting the X with the private IP address of the NetMon server you're listening on.

Startup Squid on the NetMon

Verify that the client can still connect to the Web and that Squid logs the traffic.







