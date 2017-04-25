TENANT_NETWORK_CIDR="192.168.100.0/24"
TENANT_NETWORK_GATEWAY="192.168.100.1"

neutron net-create demo-net

neutron subnet-create demo-net $TENANT_NETWORK_CIDR \
  --name demo-subnet \
  --gateway $TENANT_NETWORK_GATEWAY

neutron router-create demo-router

neutron router-interface-add demo-router demo-subnet

neutron router-gateway-set demo-router ext-net
