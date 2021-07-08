resource "random_password" "pmlo-test-rds-passwd-prod" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_security_group" "rds-pgsql" {
  name                   = "pmlo-test-rds"
  vpc_id                 = var.aws_vpc_network_id
  revoke_rules_on_delete = true

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
    Name = "pmlo-test_rds-pgsql"
  }
}



resource "aws_security_group" "rds-mysql" {
  name                   = "pmlo-test-rds-mysql"
  vpc_id                 = var.aws_vpc_network_id
  revoke_rules_on_delete = true

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pmlo-test_rds-mysql"
  }
}