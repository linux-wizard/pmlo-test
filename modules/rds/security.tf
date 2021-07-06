resource "random_password" "pmlo-test-rds-passwd-prod" {
  length           = 16
  special          = true
  override_special = "_%@"
}


resource "aws_security_group" "rds" {
  name   = "pmlo-test-rds"
  vpc_id = module.network.aws_vpc_pmlo-test-private-network-prod_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pmlo-test_rds"
  }
}