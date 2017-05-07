
Exercise 1 - Inline Network Monitor

# Overview

In this first exercise we'll be adding a rule to move traffic through a virtual machine configured with TCPDump and Snort. These are two network monitoring tools. This exercise walks through the basics of setting up your first set of chain rules.

# Goals

  * Monitor inbound web (HTTP) traffic from the client to web
  * Utilize service chains to monitor the packet flows

# Prereq
Networking Setup
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * Setup the external and internal networking

Image login info

  * admin/openstack for the CirrosWeb image
  * admin/openstack for the NetMon image

# Lab Setup

The NetMon machine will need multiple ports: at least one for management and one for data to process the traffic.

Log into the OpenStack controller via SSH
Your lab controller will be of the form ewrXXX.openstacksandiego.us
Replace XXX with your lab number and include the leading zeroes (i.e. ewr007.openstacksandiego.us)
Use the admin/openstack credential

Load the OpenStack credentials
```bash
source keystonerc_admin
```

Instances

Startup the following three images and assign floating IPs to all.

| Instance Name | Image         | Flavor  | Network(s)      | Floating IP | Interfaces          |
| ------------- |:-------------:| -------:|----------------:|------------:|--------------------:|
| Client        | CirrosWeb     | m1.tiny | internal        |  assign     | eth0                |
| WebServer     | CirrosWeb     | m1.tiny | internal        |  assign     | eth0                |
| NetMon        | NetMon        | m1.small| mgmt,service    |  assign     | eth0, eth1          |

Create ports to use for the NetMon machine, or alternatively use Horizon to attach the NetMon image to the correct network.
Note: the management and data port can be inconspicuous to the web-server's network. The administrator has the discretion to attach the NetMon interfaces on separate networks. If desired, NetMon management and service-port networks can be created prior to launching the NetMon image.

```bash
neutron port-create --name p1 internal
neutron port-create --name p2 internal
neutron port-create --name p3 internal
```

Assign floating IPs all three instances (specifically the management interface of the NetMon).

Log into CirrosWebServer
su to root (sudo su -)
Startup single line web server via netcat to display the hostname
This command is available as "hostname-webserver.sh"

``` ./hostname-webserver.sh &```

# Initial Web-server Test

Log into CirrosClient

Verify that the client can connect to the web server on the CirrosWebServer (curl <web-server_IP>), e.g.:

```$ curl 192.168.2.11```

It should return the hostname.


Log into NetworkMonitor 

Run a TCPDump to monitor for traffic to the client.

```# tcpdump dst 192.168.100.X```
or
```# tcpdump -i eth1```

```# snort dst 192.168.100.X```


Rerun the curl and validate that the NetworkMonitor does not see the traffic


# Service Chaining

Next, use MidoNet l2insertion to enable service chaining. Specifically, protect the web-server by redirecting traffic to the NetMon instance for inspection of web-server traffic.
Retrieve the UUID of both the web-server and NetMon instance's network ports. This can be retrieved via Horizon or neutron-cli. Also note the web-server MAC address for service chaining configuration.

```
# neutron port-list
# neutron port-show <web-server_UUID>
```

Log into midonet-cli to configure l2insertion of the NetMon image, to protect the web-server
```# midonet-cli
midonet-cli> list l2insertion
midonet-cli> l2insertion add port <web-server_UUID> srv-port <NetMon_UUID> fail-open true mac <web-server_MAC> 
```

Rerun the curl and validate that the NetworkMonitor _does_ see the traffic
Note: without any security software on the NetMon, the NetMon traffic will drop anything not destined for itself. Observe pings/curl requests arrive on NetMon but not forward on until a decision is made by some security software tool. 

# Example of NetMon allow policy

One simple way to enable forwarding is to use the bridge-utils and create a hairpin.

If not installed, load bridge-utils and ebtables
```
# yum install bridge-utils
# yum install ebtables 
```

Create a hairpin and prevent dupes
```
# brctl addbr br0
# brctl addif br0 eth1
# brctl stp br0 on
# brctl hairpin br0 eth1 on
# ifconfig br0 up
#
# ebtables -L
# ebtables -P OUTPUT DROP
```

Rerun the curl and validate that the NetworkMonitor _does_ see the traffic with tcpdump, and the client receives the requested information.
```
Notes...

Layer 3 versus layer 2 - running nc on NetMon would not get the traffic





