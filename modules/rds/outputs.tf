output "random_password_pmlo-test-rds-passwd-prod" {
  description = "Password used for RDS instance"
  value       = random_password.pmlo-test-rds-passwd-prod.result
  sensitive   = true
}

output "aws_db_instance_rds_engine_version" {
  description = "RDS instance hostname"
  value       = data.aws_db_instance.pmlo-test-rds.engine_version
}

output "aws_db_instance_rds_engine" {
  description = "RDS instance hostname"
  value       = aws_db_instance.pmlo-test-rds.engine
}

output "aws_db_instance_rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.pmlo-test-rds.address
  sensitive   = true
}

output "aws_db_instance_rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.pmlo-test-rds.port
  sensitive   = true
}

output "aws_db_instance_rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.pmlo-test-rds.username
}

output "aws_db_instance_rds_password" {
  description = "RDS instance root password"
  value       = aws_db_instance.pmlo-test-rds.password
  sensitive   = true
}

output "aws_db_instance_rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.pmlo-test-rds.endpoint
}