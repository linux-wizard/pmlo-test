output "ssh_private_key" {
  description = "SSH private key"
  value       = tls_private_key.pmlo-ssh-keys-gen.private_key_pem
  sensitive   = true
}

output "app-servers-ips" {
  description = "List of app-servers public IPs"
  value       = aws_instance.app_server.public_ip
  // value       = aws_instance.app_server.*.public_ip
}

output "app-servers-hostnames" {
  description = "List of app-servers public hostnames"
  value       = aws_instance.app_server.public_dns
  // value       = aws_instance.app_server.*.public_dns
}


output "rds-endpoint" {
  description = "RDS server endpoint"
  value       = module.rds.aws_db_instance_rds_endpoint
}

output "rds-username" {
  description = "RDS server username"
  value       = module.rds.aws_db_instance_rds_username
  sensitive   = true
}
