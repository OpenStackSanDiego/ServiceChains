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

* Load the OpenStack priviledges
** Source ~/keystone_admin.sh

* Add an external floating IP network
** Edit the ext-net.sh with the assigned IP range from the Workshop External Subnet above
** Source ext-net.sh to setup the floating IP addresses

* Add an internal tenant network
** Source int-net.sh to setup the internal tenant network

* Update network access rules
** Add your external IP address to the network access rules for TCP ports 22 (SSH) and 80 (HTTP)

Test External Network Setup

* Start a Cirros (tiny) image and attach to the blue network
* Associate a floating IP to the new Cirros image
* Connect to the Cirros image using SSH from your laptop  with username: admin and password: openstack


