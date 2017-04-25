
# To avoid authentication tokens leaking into GitHub,
# this must be set via evironment variable TF_VAR_packet_auth_token
variable "packet_auth_token" {
  description = "Packet auth token"
}

variable "packet_project_id" {
  description = "Packet Project ID"
}

variable "server_count" {
  description = "Total labs desired"
  default = 3
}

variable "ssh-timeout" {
  description = "ssh timeout"
  default = "900s"
}
