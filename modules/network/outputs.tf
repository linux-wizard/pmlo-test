output "my_public_ip" {
  description = "Local server IP"
  value       = local.my_public_ip
}

output "aws_security_group_pmlo-only-my_public_ip_id" {
  description = "Security group for pmlo-only-my_public_ip"
  value       = aws_security_group.pmlo-only-my_public_ip.id
}

output "aws_vpc_pmlo-test-private-network-prod_id" {
  description = "VPC ID"
  value       = aws_vpc.pmlo-test-private-network-prod.id
}

output "aws_subnet_app_subnet_id" {
  description = "Subnet ID for app-subnet"
  value       = aws_subnet.app-subnet.id
}

output "aws_subnet_rds_subnet_id-1" {
  description = "Subnet ID for rds-subnet"
  value       = aws_subnet.rds-subnet-1.id
}

output "aws_subnet_rds_subnet_id-2" {
  description = "Subnet ID for rds-subnet"
  value       = aws_subnet.rds-subnet-2.id
}

output "aws_subnet_rds_subnet_id-3" {
  description = "Subnet ID for rds-subnet"
  value       = aws_subnet.rds-subnet-3.id
}