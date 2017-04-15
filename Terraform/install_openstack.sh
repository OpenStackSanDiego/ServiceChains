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

wget -q http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2.xz
unxz CentOS-7-x86_64-GenericCloud.qcow2.xz
glance --os-image-api-version 2 image-create --protected True --name CentOS7 --visibility public --disk-format raw --container-format bare --file CentOS-7-x86_64-GenericCloud.qcow2

wget -q http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
glance --os-image-api-version 2 image-create --protected True --name cirros --visibility public --disk-format raw --container-format bare --file cirros-0.3.5-x86_64-disk.img
