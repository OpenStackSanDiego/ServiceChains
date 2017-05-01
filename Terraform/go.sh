mv srv_dns.tf srv_dns.tf.off
export TF_VAR_server_count=40 
terraform apply
export TF_VAR_server_count=48 
terraform apply
export TF_VAR_server_count=56
terraform apply
export TF_VAR_server_count=64
terraform apply
mv srv_dns.tf.off srv_dns.tf
terraform apply
