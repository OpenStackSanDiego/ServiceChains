TENANT_NETWORK_CIDR="192.168.100.0/24"
TENANT_NETWORK_GATEWAY="192.168.100.1"
TENANT_NETWORK_NAME="internal"
TENANT_ROUTER_NAME="internal-router"

neutron net-create $TENANT_NETWORK_NAME

neutron subnet-create $TENANT_NETWORK_NAME $TENANT_NETWORK_CIDR \
  --name $TENANT_NETWORK_NAME \
  --gateway $TENANT_NETWORK_GATEWAY

neutron router-create $TENANT_ROUTER_NAME

neutron router-interface-add $TENANT_ROUTER_NAME $TENANT_NETWORK_NAME

neutron router-gateway-set $TENANT_ROUTER_NAME ext-net
