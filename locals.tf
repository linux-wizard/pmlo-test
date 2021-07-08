locals {
  name-prefix                    = "ap-southeast-1-prod"
  s3_bucket                      = "pmlo-test"
  region                         = "ap-southeast-1"
  s3_tf_state_path               = "state/${local.name-prefix}-terraform.tfstate"
  dynamodb_tf_state_lock         = "tf-state-${local.name-prefix}-lock"
  aws_key_pair_pmlo_ssh_key_name = "ssh-key-${local.name-prefix}"
  ssh_user                       = "ec2-user"
  rds_database                   = "${local.container_name}-${var.env}"
  container_port                 = 8081
  container_name                 = "opencart"
}
