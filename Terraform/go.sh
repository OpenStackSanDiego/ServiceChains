
# turn off the DNS setup
mv srv_dns.tf srv_dns.tf.off

export TF_VAR_server_count=3
terraform apply


#export TF_VAR_server_count=8
#terraform apply
#export TF_VAR_server_count=16
#terraform apply
#export TF_VAR_server_count=24
#terraform apply
#export TF_VAR_server_count=32
#terraform apply
#export TF_VAR_server_count=40 
#terraform apply
#export TF_VAR_server_count=48 
#terraform apply
#export TF_VAR_server_count=56
#terraform apply
#export TF_VAR_server_count=64
#terraform apply


# turn on the DNS setup and rerun to apply the DNS settings
mv srv_dns.tf.off srv_dns.tf
terraform apply
