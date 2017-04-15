# ServiceChains


Cloud Assignments

Each workshop attendee is provided an OpenStack cloud preconfigured with the required networking plugins to support service chains.
Please refer to the following Etherpad to lookup your assigned OpenStack cloud IP <YOUR_OPENSTACK_IP>.

SSH Login

Using the IP address assigned above, connect using an SSH client to the OpenStack controller.

* ssh root@<YOUR_OPENSTACK_IP>

Open the keystone_admin file and note the password <ADMIN_PASSWORD>.

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

Please refer to the <A HREF="https://github.com/OpenStackSanDiego/ServiceChains/blob/master/Workshop%20External%20Subnets.csv">Workshop External Subnets"</A> to find your assigned IP addresses.

* Lookup your assigned subnet
* TODO - remove existing external subnet
* TODO - add in external subnet via Horizon
* TODO - setup virtual router interfaces
* TODO - setup routing on controller host and assign IPs to loopbackasdf
* TODO - lookup local IP and enable SSH and HTTP traffic via network security groups

Network Setup

Three IP subnets will be required. Using either Horizon or the command line, create the following three networks and associated subnets.

* Blue Network -  192.168.100.0/24   DHCP range 192.168.100.100,192.168.100.200
* Green Network - 192.168.200.0/24   DHCP range 192.168.200.100,192.168.200.200
* Red Network   - 192.168.300.0/24   DHCP range 192.168.300.100,192.168.300.200
* Create a router and attach it to the Blue, Green, Red and ext-net networks

Test External Network Setup

* Start a Cirros (tiny) image and attach to the blue network
* Associate a floating IP to the new Cirros image
* Connect to the Cirros image using SSH from your laptop  with username: cirros and password: cubswin:)

Exercise One - Poor Man's Web Filter

In this first example, we're going to use a service chain to push traffic through a poor man's web filter (netcat).
All outbound web traffic will be pushed through this web filter and logged.

* Cirros (tiny) - blue network
* CentOSServer (small) - blue network

Exercise Two - Poor Man's Data Leak Prevention

You've been tasked with setting up a filter to prevent credit card numbers from leaving the network. 

Startup the following virtual machines on the following networks.

* CreditCardWebServer (tiny) - blue network
* CentOSServer (small) - blue network

Exercise Three - Blocking the Bad Guys

To reduce the security exposure, you've decided to send traffic through a Squid reverse proxy to block malicious users.

* SquidProxyServer (small)

Exercise Four - Full Scale Firewall

A virtual firewall can provide a number of security functions. Next you'll be rolling out pfSense into the cloud.

* pfSense (tiny) - blue network

Exercise Five - Bringing it all Together

Service chains can include multiple network functions. Chain together both the Squid reverse proxy and the pfSense firewall.

* SquidProxyServer (small)
* pfSense (tiny)
