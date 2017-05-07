
# Exercise 1 - Inline Network Monitor

# Overview

In this first exercise we'll be adding a rule to move traffic through a virtual machine configured with TCPDump and Snort. These are two network monitoring tools. This exercise walks through the basics of setting up your first set of chain rules.

# Goals

  * Monitor inbound web (HTTP) traffic from the client to web
  * Utilize service chains to monitor the packet flows

# Prereq
##Networking Setup
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * Setup the external and internal networking
##Image login info
  * admin/openstack for the CirrosWeb image
  * admin/openstack for the NetMon image
  * admin/openstack for the physical server

# Login & Credentials

The NetMon machine will need multiple ports: at least one for management and one for data to process the traffic.

# Instances

Startup the following three images and assign floating IPs to all.

| Instance Name | Image         | Flavor  | Network(s)      | Floating IP | Interfaces          |
| ------------- |:-------------:| -------:|----------------:|------------:|--------------------:|
| Client        | CirrosWeb     | m1.tiny | internal        |  assign     | eth0                |
| WebServer     | CirrosWeb     | m1.tiny | internal        |  assign     | eth0                |
| NetMon        | NetMon        | m1.small| mgmt,service    |  assign     | eth0, eth1          |

Assign floating IPs all three instances (specifically the management interface of the NetMon).

## Startup the Web Server
* Log into CirrosWebServer via SSH using the assigned floating IP
* su to root to gain superuser privileges
```bash
$ sudo su -
```
* Startup the web server via the command "hostname-webserver.sh"
```bash
# ./hostname-webserver.sh &
```

## Initial web-server Test

We'll startup a small web server that simply responds back with a hostname string. This is simply to simulate a web server and to give us some traffic to monitor.

* Log into CirrosClient via SSH using the assigned floating IP
* Verify that the client can connect to the web server on the CirrosWebServer private IP
```bash
$ curl 192.168.2.XXX
```
* Verify that the hostname of the web server is returned as the response from the remote Web Server

## Network Traffic Monitoring

Next we'll introduce a virtual machine with some network monitoring tools installed (tcpdump and snort)

* Log into NetMon server via SSH using the assigned floating IP 
* Run a TCPDump to monitor for traffic to the client.

```bash
% sudo su -
# tcpdump dst 192.168.100.X
# tcpdump -i eth1
# snort dst 192.168.100.X
```

Rerun the curl and validate that the NetworkMonitor does not see the traffic with each of the three tcpdump and snort commands. Each monitor can be stopped with a control-c.


## Service Chaining

Next, use MidoNet l2insertion to enable service chaining. Specifically, protect the web-server by redirecting traffic to the NetMon instance for inspection of web-server traffic.


* Log into the physical OpenStack controller via SSH (ewrXXX.openstacksandiego.us)
* Load the OpenStack credentials
```bash
% sudo su -
# source keystonerc_admin
```

* Retrieve the UUID of both the web-server and NetMon instance's network ports. This can be retrieved via Horizon or neutron-cli. Also note the web-server MAC address for service chaining configuration.
```bash
% neutron port-list
% neutron port-show <web-server_UUID>
```

* Via the midonet-cli configure L2-insertion of the NetMon instance for protecting the web-server
```bash
# midonet-cli
midonet-cli> list l2insertion
midonet-cli> l2insertion add port <web-server_UUID> srv-port <NetMon_UUID> fail-open true mac <web-server_MAC> 
```

* Return to NetMon and restart the tcpdump and/or snort commands to monitor traffic
* Return to Client and rerun the curl commands to generate some network traffic
* Validate that the NetworkMonitor _does_ see the traffic

However, traffic will traverse fully between the client and web servers. Network traffic arrives on NetMon but not forward on until a decision is made by some security software tool or the interfaces are bridged to allow traffic to pass. This allows the NetMon virtual machine to block malicious traffic (i.e. via Snort rules). We'll next see how to bridge traffic through the interfaces.

#  NetMon Policy Examples

One simple way to enable forwarding is to use the bridge-utils and create a hairpin.

* Install bridge-utils and ebtables on NetMon
```bash
% sudo su -
# yum install bridge-utils
# yum install ebtables 
```

* Create a hairpin and prevent dupes
```bash
# brctl addbr br0
# brctl addif br0 eth1
# brctl stp br0 on
# brctl hairpin br0 eth1 on
# ifconfig br0 up
#
# ebtables -L
# ebtables -P OUTPUT DROP
```

* Rerun the curl and validate that the NetworkMonitor _does_ see the traffic with tcpdump, and the client receives the requested information.

## 
Example NetMon policy via snort

Disable hairpin, if done in previous step.
```
brctl hairpin br0 eth1 off
```
Backup default snort.conf and replace with minimum config in `/etc/snort/snort.conf`
```
# Setup the network addresses you are protecting
ipvar HOME_NET 192.168.100.6

# Set up the external network addresses. Leave as "any" in most situations
ipvar EXTERNAL_NET any

var RULE_PATH /etc/snort/rules
var SO_RULE_PATH /etc/snort/so_rules
var PREPROC_RULE_PATH /etc/snort/preproc_rules
var WHITE_LIST_PATH  /etc/snort/rules
var BLACK_LIST_PATH /etc/snort/rules
include $RULE_PATH/local.rules
config policy_mode:inline
```

Add rules to snort configuration file `/etc/snort/rules/local.rules` for alerts or drops. Note, afpacket capture type duplicates the packet and sends output to screen by default.

```
[root@netmon centos]# cat /etc/snort/rules/local.rules 
#alert tcp any any <> $HOME_NET 80 (msg:"Sample alert"; flow: to_server,established;sid:40000001) 
alert tcp any any -> $HOME_NET 80 (msg:"http request";flow:from_client;sid:40000001)
alert tcp $HOME_NET 80 -> any any (msg:"http reply";flow:to_client;sid:40000002)
#alert icmp any any -> $HOME_NET any
#drop tcp any any <> $HOME_NET 80
#drop icmp any any -> $HOME_NET any
```
Run snort while sending client traffic
```
snort -Q -A console --daq afpacket -q -c /etc/snort/snort.conf -i eth1:br0
```

```
Notes...

Layer 3 versus layer 2 - running nc on NetMon would not get the traffic





