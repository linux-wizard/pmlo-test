terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.13.0"
    }
  }
}


provider "postgresql" {
  scheme           = "awspostgres"
  host             = var.rds_endpoint
  port             = 5432
  database         = "postgres"
  username         = var.rds_username
  password         = var.rds_password
  connect_timeout  = 15
  superuser        = false
  expected_version = var.rds_engine_version
}

// resource "postgresql_database" "my_db" {
//   name              = var.rds_database
//   owner             = var.rds_username
//   template          = "template0"
//   lc_collate        = "C"
//   connection_limit  = -1
//   allow_connections = true
// }

// resource "postgresql_role" "app-user-role" {
//   name     = var.rds_username
//   login    = true
//   password = random_password.pmlo-test-app-passwd-prod.result
// }


// resource "postgresql_grant" "app-tables" {
//   database    = var.rds_database
//   role        = var.rds_username
//   schema      = "public"
//   object_type = "table"
//   privileges = ["SELECT", "INSERT", "UPDATE", "DELETE",
//     "TRUNCATE", "REFERENCES", "TRIGGER", "CREATE",
//   "CONNECT", "TEMPORARY", "EXECUTE", "USAGE"]
// }