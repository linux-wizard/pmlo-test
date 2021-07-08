// module "network" {
//   source = "../network"
// }


resource "aws_db_subnet_group" "pmlo-test-rds" {
  name = "pmlo-rds-subnet-prod"
  // subnet_ids = [
  //   "${module.network.aws_subnet_rds_subnet_id-1}",
  //   "${module.network.aws_subnet_rds_subnet_id-2}",
  //   "${module.network.aws_subnet_rds_subnet_id-3}"
  // ]
  //subnet_ids = var.network_aws_subnet_rds_subnet_ids
  subnet_ids = var.network_aws_subnet_private_subnet_ids

  tags = {
    Name = "RDS DB subnet"
  }
}


resource "aws_db_parameter_group" "pmlo-test-rds-conf" {
  name        = "pmlo-test-rds-pgsql-prod"
  description = "Parameter group for RDS PostgreSQL"
  // taken from aws rds describe-db-engine-versions --default-only --engine postgres
  family = "postgres12"

  // To get list of parameters
  // aws rds create-db-parameter-group --db-parameter-group-name test-postgresql --db-parameter-group-family "postgres13" --description "test paraneter group for PGSQL"
  // aws rds describe-db-parameters --db-parameter-group-name test-postgresql > pgsql-db-parameters.txt
  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "pmlo-test-rds" {
  identifier        = "pmlo-test-rds-pgsql-prod"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  engine            = "postgres"
  // engine_version         = "13.1"
  username               = "postgres"
  backup_window          = "01:00-01:30"
  maintenance_window     = "sun:03:00-sun:03:30"
  password               = random_password.pmlo-test-rds-passwd-prod.result
  db_subnet_group_name   = aws_db_subnet_group.pmlo-test-rds.id
  vpc_security_group_ids = [aws_security_group.rds-pgsql.id]
  parameter_group_name   = aws_db_parameter_group.pmlo-test-rds-conf.name
  publicly_accessible    = true
  skip_final_snapshot    = true

  // performance_insights_enabled          = var.performance_insights_enabled
  // performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  // performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
}

data "aws_db_instance" "pmlo-test-rds" {
  db_instance_identifier = aws_db_instance.pmlo-test-rds.name
}