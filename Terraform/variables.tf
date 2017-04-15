
# To avoid authentication tokens leaking into GitHub,
# this must be set via evironment variable TF_VAR_packet_auth_token
variable "packet_auth_token" {
  description = "Packet auth token"
}

variable "packet_project_id" {
  description = "Packet Project ID"
}

variable "server_count" {
  description = "Total running servers"
  default = 2
}

variable "ssh-timeout" {
  description = "ssh timeout"
  default = "900s"
}

variable "server_ip" {
  type    = "map"
  default = {
	ubuntu001 = "10.10.10.1"
        ubuntu002 = "10.10.10.2"
        ubuntu003 = "10.10.10.3"
        ubuntu004 = "10.10.10.4"
        ubuntu005 = "10.10.10.5"
        ubuntu006 = "10.10.10.6"
  }
}
