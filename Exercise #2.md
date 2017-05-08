
# Exercise 2 - Snort Monitoring and Alerting

# Overview

In this exercise you'll be using Snort to monitor and alert when monitoring. Traffic will flow through two NetMon machines to illustrate chaining. The first is the TCPDump monitoring and the second will run Snort.

# Goals

  * Monitor inbound web (HTTP) traffic from the client to web via TCPDump and Snort NetMon
  * Utilize service chains to monitor the packet flows

# Prereq

## Networking Setup
  * Setup network security groups to allow SSH and HTTP to the project from your laptop external network
  * Setup the external and internal networking
  
## Image login info
  * admin/openstack for the CirrosWeb image
  * admin/openstack for the NetMon image
  * admin/openstack for the physical server

## Service and management networks

Use the same service and management networks from earlier exercises.

Startup the following three images and assign floating IPs to all. 

| Instance Name | Image         | Flavor  | Network(s)      | Floating IP | Interfaces          | Notes                            |
| ------------- |:-------------:| -------:|----------------:|------------:|--------------------:|---------------------------------:|
| Client        | CirrosWeb     | m1.tiny | internal        |  assign     | eth0                | reuse from previous exercise     |
| WebServer     | CirrosWeb     | m1.tiny | internal        |  assign     | eth0                | reuse from previous exercise     |
| NetMon        | NetMon        | m1.small| mgmt,service    |  assign     | eth0, eth1          | reuse from previous exercise     | 
| Snort         | NetMon        | m1.small| mgmt,service    |  assign     | eth0, eth1          | new machine for this exercise    | 

Assign floating IPs all three instances. The NetMon floating IP will be to eth0 on the mgmt network.

## Network Traffic Monitoring

Next we'll introduce a second virtual machine with some network monitoring tools installed (tcpdump and snort)

* Log into Snort server via SSH using the assigned floating IP 
* Run a Snort to monitor for traffic to the client.

```bash
% sudo su -
# snort XYZ
```

Rerun the curl and validate that the NetworkMonitor does not see the traffic with the tcpdump commands. The monitor can be stopped with a control-c.


## Service Chaining

Next, use MidoNet L2-insertion to enable service chaining. Specifically, protect the web-server by redirecting traffic to the NetMon instance for inspection of web-server traffic.


* Log into the physical OpenStack controller via SSH (ewrXXX.openstacksandiego.us)
* Load the OpenStack credentials
```bash
% sudo su -
# source keystonerc_admin
```

* Retrieve the UUID of both the web-server and NetMon instance's network ports. This can be retrieved via Horizon or neutron-cli. Also note the web-server MAC address for service chaining configuration.
* Via Horizon Network->Networks->internal->Ports and select the port ID corresponding to the web server and Snort IP addresses for the web-server-port-UUID, Snort-port-UUID MAC address.
```bash
% neutron port-list
% neutron port-show <web-server-port-UUID>
```

* Via the `midonet-cli` configure L2-insertion of the NetMon instance for protecting the web-server
```bash
# midonet-cli
midonet-cli> list l2insertion
midonet-cli> l2insertion add port <web-server-port-UUID> srv-port <Snort-port-UUID> fail-open true mac <web-server-MAC> 
```

* Return to Snort and restart the snort commands to monitor traffic
* Return to Client and rerun the curl commands to generate some network traffic
* Validate that Snort _does_ see the traffic

However, traffic will not traverse between the client and web servers. Network traffic arrives on NetMon but not forward on until a decision is made by some security software tool or the interfaces are bridged to allow traffic to pass. This allows the NetMon virtual machine to block malicious traffic. Next we'll see how to bridge traffic through the interfaces.

#  Enable Packet Bridging

One simple way to enable packet forwarding is to use the bridge-utils and create a hairpin.

* Install bridge-utils and ebtables on NetMon
```bash
% sudo su -
# yum install bridge-utils
```

* Create a hairpin and prevent dupes
```bash
# brctl addbr br0
# brctl addif br0 eth1
# brctl stp br0 on
# brctl hairpin br0 eth1 on
# ifconfig br0 up
```

* Rerun the curl and validate that the Snort _does_ see the traffic, and the client receives the requested information.

One you're satisfied that you can direct and monitor traffic proceed to the <A HREF="https://github.com/OpenStackSanDiego/ServiceChains/blob/master/Exercise%20%233.md">next exercise</A>.




