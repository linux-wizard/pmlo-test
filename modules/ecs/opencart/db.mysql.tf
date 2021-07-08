// terraform {
//   required_providers {
//     mysql = {
//       source  = "winebarrel/mysql"
//       version = "~> 1.10.2"
//     }
//   }
//   required_version = ">= 0.13"
// }

// # Configure the MySQL provider
// provider "mysql" {
//   endpoint = var.rds_endpoint
//   username = var.rds_username
//   password = var.rds_password
// }

// # Create a Database
// resource "mysql_database" "xwiki" {
//   name = var.rds_database

//   lifecycle {
//     prevent_destroy = true
//   }
// }

// resource "mysql_user" "xwiki" {
//   user               = "xwiki"
//   host               = "%"
//   plaintext_password = random_password.pmlo-test-xwiki-passwd-prod.result
// }

// resource "mysql_grant" "xwiki" {
//   user       = mysql_user.xwiki.user
//   host       = mysql_user.xwiki.host
//   database   = var.rds_database
//   privileges = ["*"]
// }
