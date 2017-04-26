# ServiceChains

Overview

This workshop will teach you how to use network rule chains to push traffic through security functions. This allows security functions, such as network monitors, IDS/IPS, web filters and web proxies, to be placed inline with the network traffic without having to route traffic through layer 3 IPs.

As part of this workshop, each attendee will be assigned a physical server running their own private OpenStack cloud. This physical server can be access via SSH or the Horizon GUI. Each physical server has 32 GB of RAM and 6 floating IP addresses. This allows six virtual machines to run comfortably in the cloud. The floating IP addresses allow remote network access to the virtual machines.

The Midonet neutron plugin has been installed to allow the service chaining. For more information about rule chains in Midonet, please read: https://docs.midonet.org/docs/latest/operations-guide/content/rule_chains.html

This workshop consists of a number of exercises going from the basics through more advanced configurations. Once you've completed the steps below to familiarize your self and configure the lab, please proceed to the exercises.

Cloud Assignments

Each workshop attendee is provided an OpenStack cloud preconfigured with the required networking plugins to support service chains. When you arrive at the workshop, you'll be assigned a lab number (i.e. 001), a server name (i.e. ewr001.openstacksandiego.us) and a password.

SSH Login

Using the IP address assigned above, connect using an SSH client to the OpenStack controller using an SSH client such as PuTTY. PuTTY for Windows can be downloaded at http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html.

Once logged into the physical server, view the keystone_admin file and note the password <ADMIN_PASSWORD>.

* cat keystone_admin

Horizon Login

Using the IP address assigned above, connect and log into the Horizon web interface at
* http://<YOUR_OPENSTACK_IP/horizon
* Domain: default
* User Name: admin
* Password: <ADMIN_PASSWORD>

External Network Setup

Each workshop lab environment has been allocated a set of IP addresses with external connectivity.
These IP addresses need to be setup within OpenStack.

Please refer to the <A HREF="https://github.com/OpenStackSanDiego/ServiceChains/blob/master/Workshop%20External%20Subnets.csv">Workshop External Subnets"</A> to find your assigned IP addresses. We've provided some scripts to setup the external and internal networking. However, you'll need to update the external networking script with your specific assigned IP addresses.

* Load the OpenStack priviledges
** Source ~/keystone_admin.sh

* Add an external floating IP network
** Edit the ext-net.sh with the assigned IP range from the Workshop External Subnet above
** Source ext-net.sh to setup the floating IP addresses
** sh ext-net.sh

* Add an internal tenant network
** Source int-net.sh to setup the internal tenant network
** sh int-net.sh

* Update network access rules to allow SSH & HTTP
** Add your external IP address to the network access rules for TCP ports 22 (SSH) and 80 (HTTP)
** https://ifconfig.co// will tell you your external IP address
** Compute->Access & Security->Manage Rules->+ Add Rule
** Rule: SSH CIDR: YOUR_IP
** Rule: HTTP CIDR: YOUR_IP

Test External Network Setup

For instructions on how to launch instances, please see:
https://docs.openstack.org/user-guide/dashboard-launch-instances.html

* Start a Cirros (tiny) image and attach to the internal network

| Instance Name | Image         | Flavor  | Network  |
| ------------- |:-------------:| -------:|---------:|
| Client        | CirrosWeb     | m1.tiny | Internal |

* Associate a floating IP to the new Cirros image
* Connect to the Cirros image using SSH from your laptop with username: admin and password: openstack

If you can login OK, then external networking is all setup and you can proceed to exercise #1.


