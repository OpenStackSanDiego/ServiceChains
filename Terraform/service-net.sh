TENANT_NETWORK_CIDR="10.0.0.0/24"
TENANT_NETWORK_NAME="service"

neutron net-create $TENANT_NETWORK_NAME

neutron subnet-create $TENANT_NETWORK_NAME $TENANT_NETWORK_CIDR \
  --name $TENANT_NETWORK_NAME

# no router for service network
# no router-gateway to ext-net for service network
