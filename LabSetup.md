# Overview

These steps will take you through setting up your OpenStack cloud lab environment for these exercises.

## Goals

  * Access via SSH and the web the OpenStack lab environment
  * Setup external networking
  * Startup and access via SSH a test virtual machine

## Prereq

Lab Details
  * Know the lab # that you've been assigned (i.e. lab007)

## Login info
  * admin/openstack for the CirrosWeb image
  * admin/openstack for the NetMon image
  * admin/openstack for the physical server

### SSH Login

Using the IP address assigned above, connect using an SSH client to the OpenStack controller using an SSH client such as PuTTY. PuTTY for Windows can be downloaded at http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html.

* ssh to your physical server (ewrXXX.openstacksandiego.us) replacing XXX with your lab number.

Once logged into the physical server, view the keystone_admin file and note the password. The password is set as the variable OS_PASSWORD (export OS_PASSWORD=<ADMIN_PASSWORD>).

* record the admin password

```bash
# cat keystone_admin
```

### Horizon Login

Using the IP address assigned above, connect and log into the Horizon web interface at
* http://<YOUR_OPENSTACK_IP/horizon
* Domain: default
* User Name: admin
* Password: <ADMIN_PASSWORD>

## External Network Setup

Each workshop lab environment has been allocated a set of IP addresses with external connectivity.
These IP addresses need to be setup within OpenStack.

Please refer to the <A HREF="https://github.com/OpenStackSanDiego/ServiceChains/blob/master/Workshop%20External%20Subnets.csv">Workshop External Subnets"</A> to find your assigned IP addresses. We've provided some scripts to setup the external and internal networking. However, you'll need to update the external networking script with your specific assigned IP addresses.

### Load the OpenStack priviledges
```bash
$ sudo su -
# source ~/keystone_admin.sh
```

### Add an external floating IP network
* Edit the ext-net.sh with the assigned IP range from the Workshop External Subnet above
* Source ext-net.sh to setup the floating IP addresses
```
# vi ext-net.sh
# source ext-net.sh
```

### Add an internal tenant network
* Source int-net.sh to setup the internal tenant network
```bash
# source int-net.sh
```

### Update network access rules to allow SSH & HTTP
* Add your external IP address to the network access rules for TCP ports 22 (SSH) and 80 (HTTP)
* https://ifconfig.co// will tell you your external IP address
* Compute->Access & Security->Manage Rules->+ Add Rule
* Rule: SSH CIDR: YOUR_IP
* Rule: HTTP CIDR: YOUR_IP

### Test External Network Setup

For instructions on how to launch instances, please see:
https://docs.openstack.org/user-guide/dashboard-launch-instances.html

#### Start a test VM

* Start a Cirros (tiny) image and attach to the internal network

| Instance Name | Image         | Flavor  | Network  |
| ------------- |:-------------:| -------:|---------:|
| Client        | CirrosWeb     | m1.tiny | Internal |

* Associate a floating IP to the new Cirros image
* Connect to the Cirros image using SSH from your laptop with username: admin and password: openstack

If you can login OK, then external networking is all setup and you can proceed to exercise #1 https://github.com/OpenStackSanDiego/ServiceChains/blob/master/Exercise%20%231.md.


