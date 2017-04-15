terraform {
  required_version = ">= 0.9.3"
}

resource "packet_device" "controller" {
  count = "${var.server_count}"

  hostname = "${format("ubuntu%03d", count.index + 1)}"

  plan = "baremetal_1"
  facility = "ewr1"
  operating_system = "ubuntu_14_04"
  billing_cycle = "hourly"
  project_id = "${var.packet_project_id}"

#  var.server_ip["${hostname}"] = "${network.0.address}"
#  var.server_ip[packet_device.hostname] = "20.20.20.20"
#  var.server_ip["${element(packet_device.controller.*.hostname, count.index)}"] = "20.20.20.20"

  connection {
        type = "ssh"
        user = "root"
        port = 22
        timeout = "${var.ssh-timeout}"
        private_key = "${file("OpenStackWorkshop-id_rsa")}"
  }

  provisioner "file" {
    source      = "install_openstack.sh"
    destination = "/tmp/install_openstack.sh"
  }

  provisioner "remote-exec" {
       inline = [
        "chmod +x /tmp/install_openstack.sh",
        "/tmp/install_openstack.sh",
       ]
  }
}

resource "dnsimple_record" "controller" {
  count  = "${var.server_count}"

  domain = "openstacksandiego.us"
  name   = "${element(packet_device.controller.*.hostname, count.index)}"
  value   = "${lookup(var.server_ip,element(packet_device.controller.*.hostname, count.index))}"

  type   = "A"
  ttl    = 3600
}
