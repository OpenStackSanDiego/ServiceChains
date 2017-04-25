apt-get update -y
apt-get install git-all -y
apt-get install systemd-shim -y
apt-get install apparmor -y

rm -rf aomi
git clone https://github.com/midonet/aomi
cd aomi

apt-get update
apt-get install -qqy software-properties-common sshpass
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -qqy ansible python-netaddr
ansible-galaxy install -r requirements.yml

mv roles/rabbitmq/templates/.config.j2 roles/rabbitmq/templates/rabbitmq.config.j2
mv roles/rabbitmq/templates/erlang.cookie.j2 roles/rabbitmq/templates/rabbitmq.erlang.cookie.j2
mv -- roles/rabbitmq/templates/-env.conf.j2 roles/rabbitmq/templates/rabbitmq-env.conf.j2

ansible-playbook -i localhost, -c local playbooks/allinone/midonet-allinone.yml

. /root/keystonerc_admin

# blow out the 200.200.200.0/24 example created by Aomi
ROUTER=edge-router
SUBNET=$(neutron router-port-list -F fixed_ips $ROUTER | grep '"ip_address": "200.200.200.1"' | awk '{print $3}' | tr -d '\n",')
neutron router-interface-delete $ROUTER $SUBNET
neutron subnet-delete $SUBNET


IMAGE_SERVER=shell.openstacksandiego.us

IMG_FILE=CentOS-7-x86_64-GenericCloud.qcow2
IMG_NAME=CentOS7
wget -q -O - http://$IMAGE_SERVER/Images/$IMG_FILE | \
glance --os-image-api-version 2 image-create --protected True --name $IMG_NAME --visibility public --disk-format raw --container-format bare

IMG_FILE=xenial-server-cloudimg-amd64-disk1.img
IMG_NAME=Ubuntu14_04
wget -q -O - http://$IMAGE_SERVER/Images/$IMG_FILE | \
glance --os-image-api-version 2 image-create --protected True --name $IMG_NAME --visibility public --disk-format raw --container-format bare

IMG_FILE=CirrosWeb.img
IMG_NAME=CirrosWeb
wget -q -O - http://$IMAGE_SERVER/Images/$IMG_FILE | \
glance --os-image-api-version 2 image-create --protected True --name $IMG_NAME --visibility public --disk-format raw --container-format bare

IMG_FILE=pfSense-small.img
IMG_NAME=pfSense
wget -q -O - http://$IMAGE_SERVER/Images/$IMG_FILE | \
glance --os-image-api-version 2 image-create --protected True --name $IMG_NAME --visibility public --disk-format raw --container-format bare

IMG_FILE=NetMon.img
IMG_NAME=NetMon
wget -q -O - http://$IMAGE_SERVER/Images/$IMG_FILE | \
glance --os-image-api-version 2 image-create --protected True --name $IMG_NAME --visibility public --disk-format raw --container-format bare

IMG_FILE=IoT.img
IMG_NAME=IoT
wget -q -O - http://$IMAGE_SERVER/Images/$IMG_FILE | \
glance --os-image-api-version 2 image-create --protected True --name $IMG_NAME --visibility public --disk-format raw --container-format bare


# enable password logins
adduser admin --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "admin:openstack" | sudo chpasswd
adduser admin sudo
sed -i "/PasswordAuthentication no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service ssh restart

