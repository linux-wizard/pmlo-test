output "ssh_private_key" {
  description = "SSH private key"
  value       = tls_private_key.pmlo-ssh-keys-gen.private_key_pem
  sensitive   = true
}

output "host_key_rsa_fingerprint" {
  value = tls_private_key.pmlo-ssh-keys-gen.public_key_fingerprint_md5
}

output "app-servers-ips" {
  description = "List of app-servers public IPs"
  //value       = aws_instance.app_server.public_ip
  value = aws_instance.app_server.*.public_ip
}

output "app-servers-hostnames" {
  description = "List of app-servers public hostnames"
  //value       = aws_instance.app_server.public_dns
  value = aws_instance.app_server.*.public_dns
}

output "rds-engine" {
  description = "RDS server engine"
  value       = module.rds.aws_db_instance_rds_engine
}

output "rds-endpoint" {
  description = "RDS server endpoint"
  value       = module.rds.aws_db_instance_rds_endpoint
}

output "rds-username" {
  description = "RDS server username"
  value       = module.rds.aws_db_instance_rds_username
}

output "rds-password" {
  description = "RDS server username"
  value       = module.rds.aws_db_instance_rds_password
  sensitive   = true
}

output "rds-database" {
  description = "RDS database"
  value       = var.rds_database
}

output "app-lb-dns" {
  description = "App LB DNS"
  value       = module.ecs_opencart.aws_lb_app_dns
}

// output "ecr_repository_worker_endpoint" {
//     value = module.ecs_xwiki.ecr_repository_worker_endpoint
// }
