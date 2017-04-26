
Exercise 1 - Inline Network Monitor

Overview

In this first exercise we'll be adding a rule to move traffic through a virtual machine configured with TCPDump and Snort. These are two network monitoring tools. This exercise walks through the basics of setting up your first set of chain rules.

Goals

  * Monitor inbound web (HTTP) traffic from the client to web
  * Utilize service chains to monitor the packet flows

Image login info:

  * admin/openstack for the CirrosWeb image
  * admin/openstack for the NetMon image

Prereq
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * Setup the external and internal networking

Instances

Startup the following three images and assign floating IPs to all.

| Instance Name | Image         | Flavor  | Network  | Floating IP |
| ------------- |:-------------:| -------:|---------:|------------:|
| Client        | CirrosWeb     | m1.tiny | internal |  assign     |
| WebServer     | CirrosWeb     | m1.tiny | internal |  assign     |
| NetMon        | NetMon        | m1.small| internal |  assign     |


Assign floating IPs all three instances.

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

# tcpdump dst 192.168.100.X

# snort dst 192.168.100.X

Rerun the curl and validate that the NetworkMonitor does not see the traffic

Setup Port Networking

Setup OpenStack networking to chain traffic destined for the WebServer via the NetworkMonitor

Rerun the curl and validate that the NetworkMonitor _does_ see the traffic


Notes...

Layer 3 versus layer 2 - running nc on NetMon would not get the traffic





