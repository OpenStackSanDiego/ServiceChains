Exercise 2 - Malicious IoT Detection and Blocking

# Overview

A number of malicous IoT (Internet of Things) devices are running on your network! It's your job to analyze the traffic to determine how it is communicating and block the traffic.

Each IoT device is communicating with a "Command and Control" server at least every 60 seconds using either TDP or UDP. Using TCPDump and/or Snort, determine what remote IP(s) the device is communicating and block that IP. Utilize a second NetMon to verify that the traffic is being blocked.

No login credentials are provided for the IoT box. You should consider it a black box where you can only examine traffic in/out of the virtual machine.

# Goals

  * Detect outbound message by the rogue IoT device
  * Block and log the malicious messages
  * Utilize service chains to manipulate the packet flows

# Tools

  * NetMon image is equipped with Snort and TCPDump
  * TCPDump usage information: http://www.tcpdump.org/tcpdump_man.html
  * Snort usage information: http://www.manpagez.com/man/8/snort/

# Prereq
Networking Setup:
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * Setup the external and internal networking

Image login info:

  * admin/openstack for the NetMon images
  * no login available for the IoT boxes - consider it a black box!

# Lab Setup

Instances

Startup the following three images and assign floating IPs to all.

| Instance Name | Image         | Flavor   | Network  | Floating IP |
| ------------- |:-------------:| --------:|---------:|------------:|
| IoT           | IoT           | m1.small | internal |  assign     |
| NetMon-1      | NetMon        | m1.small | internal |  assign     |
| NetMon-2      | NetMon        | m1.small | internal |  assign     |


Use L2 service-insertion or port-mirroring to monitor rogue traffic on the network on the NetMon instance.










