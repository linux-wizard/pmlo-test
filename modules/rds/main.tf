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
  name        = "pmlo-test-rds-conf-prod"
  description = "Parameter group for RDS MariaDB"
  // taken from aws rds describe-db-engine-versions --default-only --engine postgres
  // family = "postgres13"

  // taken from aws rds describe-db-engine-versions --default-only --engine mariadb
  family = "mariadb10.4"

  // parameter {
  //   name  = "log_connections"
  //   value = "1"
  // }

  parameter {
    name  = "general_log"
    value = "1"
  }
  parameter {
    name  = "long_query_time"
    value = "2"
  }
  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  parameter {
    name  = "log_throttle_queries_not_using_indexes"
    value = "1"
  }
  parameter {
    name  = "log_throttle_queries_not_using_indexes"
    value = "1"
  }
  parameter {
    name  = "log_output"
    value = "FILE"
  }

  // Only log to table on staging environment as this can impact performances
  // dynamic "parameter" {
  //   for_each = var.env ? "stg" : ""
  //   content {
  //     name = "log_output"
  //     value = "TABLE"
  //   }
  //   parameter {
  //     name  = "log_output"
  //     value = "TABLE"
  // }
  // }

}

resource "aws_db_instance" "pmlo-test-rds" {
  identifier             = "pmlo-test-rds-prod"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mariadb"
  engine_version         = "10.4.13"
  username               = "pmlo_test_root_user"
  password               = random_password.pmlo-test-rds-passwd-prod.result
  db_subnet_group_name   = aws_db_subnet_group.pmlo-test-rds.id
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.pmlo-test-rds-conf.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}