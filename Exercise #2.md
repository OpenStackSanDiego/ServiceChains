
# Exercise 2 - Inline Network Blocking

# Overview

In this exercise we'll be managing what traffic is allowed through the service chain.

# Goals

  * Monitor and block/allow inbound web (HTTP) traffic from the client to web
  * Utilize service chains to monitor and block/allow the packet flows

# Prereq
##Networking Setup
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * Setup the external and internal networking
  * All of the instances from Exercise #1 running with the web server running
##Image login info
  * admin/openstack for the CirrosWeb image
  * admin/openstack for the NetMon image
  * admin/openstack for the physical server

## Instances
* Reuse all of the instances from exercise #1
* Make sure the web server is still running from exercise #1

## Network Traffic Blocking

* Disable hairpin, if done in previous step.
```
# brctl hairpin br0 eth1 off

```bash
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


