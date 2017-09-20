# somewhat recent version is needed for DNSimple
terraform {
  required_version = ">= 0.9.3"
}

resource "dnsimple_record" "controller" {
  count  = "${var.server_count}"

  domain = "openstacksandiego.us"
  name   = "${element(packet_device.controller.*.hostname, count.index)}"
  value  = "${element(packet_device.controller.*.network.access_public_ipv4, count.index)}"

  type   = "A"
  ttl    = 3600
}
