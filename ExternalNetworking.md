  
  
Clean up the Default External Network

Remove the 200.200.200.1 interface to the edge-router

* Network->Routers->Interfaces   
* Remove the 200.200.200.1 interface

Delete the 200.200.200.0/24 subnet

* Admin->System->Network->ext-net
* Select ext-subnet and "Delete Subnets"

Add the Assigned Floating Subnet

* Refer to the <a href="Workshop%20External%20Subnets.csv">External Subnet</a> to find your assigned subnet.
* Update the "ext-net.sh" script with the assigned subnet info.
