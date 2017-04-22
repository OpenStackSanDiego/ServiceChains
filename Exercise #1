
Exercise 1 - Port Assignment

Image login info:
  admin/openstack for all images

Prereq
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * http://www.whatsmyip.org/
  

Instances

| Instance Name | Image         | Flavor  | Network  |
| ------------- |:-------------:| -------:|---------:|
| Client        | Cirros        | m1.tiny | Internet |
| WebServer     | Cirros        | m1.tiny | Internet |
| NetTools      | NetTools      | m1.tiny | Internet |

Startup Three Image

* CirrosClient (Image: CirrosImage flavor tiny network: internal
* CirrosWebServer image (Image: CirrosImage flavor tiny network: internal)

Startup One CentOS monitoring agent

* NetworkMonitoringTools image (flavor small network: internal)

Assign floating IPs all three instances

Log into CirrosWebServer
su to root (sudo su -)
Startup single line web server via netcat to display the hostname
This command is available as "hostname-webserver.sh"

# ./hostname-webserver.sh

Log into CirrosClient

Verify that the client can connect to the web server on the CirrosWebServer
$ curl 192.168.2.11

It should return the hostname.

Log into NetworkMonitor 

Run a TCPDump to monitor for traffic to the client.

# tcpdump dst 192.168.2.11

# snort dst 192.168.2.11

Rerun the curl and validate that the NetworkMonitor does not see the traffic

Setup Port Networking

Setup OpenStack networking to chain traffic destined for the WebServer via the NetworkMonitor

Rerun the curl and validate that the NetworkMonitor _does_ see the traffic


Notes...

Layer 3 versus layer 2 - running nc on NetMon would not get the traffic





