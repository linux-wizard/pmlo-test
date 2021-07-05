module "network" {
  source = "../network"
}


resource "aws_db_subnet_group" "pmlo-test-rds" {
  name = "pmlo-rds-subnet-prod"
  subnet_ids = [
    "${module.network.aws_subnet_rds_subnet_id-1}",
    "${module.network.aws_subnet_rds_subnet_id-2}",
    "${module.network.aws_subnet_rds_subnet_id-3}"
  ]

  tags = {
    Name = "RDS DB subnet"
  }
}


resource "aws_db_parameter_group" "pmlo-test-rds-conf" {
  name   = "pmlo-test-rds-conf-prod"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "pmlo-test-rds" {
  identifier             = "pmlo-test-rds-prod"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "pmlo_test_root_user"
  password               = random_password.pmlo-test-rds-passwd-prod.result
  db_subnet_group_name   = aws_db_subnet_group.pmlo-test-rds.id
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.pmlo-test-rds-conf.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}