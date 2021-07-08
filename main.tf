terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }

  backend "s3" {
    key            = "state/ap-southeast-1-prod-terraform.tfstate"
    bucket         = "pmlo-test"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "tf-state-ap-southeast-1-prod-lock"
    // skip_region_validation      = true
    // skip_credentials_validation = true
    // skip_metadata_api_check     = true
  }


  required_version = ">= 0.14.9"
}


module "network" {
  source         = "./modules/network"
  container_port = local.container_port
  container_name = local.container_name
}

module "rds" {
  source                                = "./modules/rds"
  network_aws_subnet_private_subnet_ids = module.network.aws_subnet_private_subnet_ids
  aws_vpc_network_id                    = module.network.aws_vpc_pmlo-test-private-network-prod_id
  container_port                        = local.container_port
  container_name                        = local.container_name
}

module "ecs_opencart" {
  source = "./modules/ecs/opencart"
  region = var.region
  env    = var.env

  aws_vpc_network_id       = module.network.aws_vpc_pmlo-test-private-network-prod_id
  aws_public_subnets_ids   = module.network.aws_subnet_app_subnet_ids
  aws_private_subnets_ids  = module.network.aws_subnet_private_subnet_ids
  rds_endpoint             = module.rds.aws_db_instance_rds_endpoint
  rds_username             = module.rds.aws_db_instance_rds_username
  rds_password             = module.rds.aws_db_instance_rds_password
  rds_engine_version       = module.rds.aws_db_instance_rds_engine_version
  rds_database             = var.rds_database
  app_user                 = "app-user-${var.env}"
  aws_instance_default_ami = var.aws_instance_default_ami
  container_port           = local.container_port
  container_name           = local.container_name
}

// Enable remote state data source to be able to pass info around modules
// data "terraform_remote_state" "pmlo-state" {
//     backend = "s3"
//     config {
//         bucket  = var.s3_bucket
//         key     = var.tf_state_path
//         region  = var.region
//     }
// }

resource "random_string" "app_random" {
  length  = "3"
  special = false
  number  = true
  upper   = false
}

resource "tls_private_key" "pmlo-ssh-keys-gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

provider "aws" {
  profile = "default"
  region  = local.region
}

// Generate SSH key
resource "aws_key_pair" "pmlo-ssh-key" {
  key_name   = local.aws_key_pair_pmlo_ssh_key_name
  public_key = tls_private_key.pmlo-ssh-keys-gen.public_key_openssh
}

resource "aws_instance" "app_server" {
  ami           = var.aws_instance_default_ami
  instance_type = var.aws_instance_default_type
  key_name      = local.aws_key_pair_pmlo_ssh_key_name
  //   security_groups   = ["${aws_security_group.pmlo-only-my_public_ip.id}"]
  //   subnet_id         = "${aws_subnet.app-subnet.id}"
  security_groups = ["${module.network.aws_security_group_pmlo-only-my_public_ip_id}"]
  subnet_id       = module.network.aws_subnet_app_subnet_ids[0]
  count           = var.app_count


  // provisioner "remote-exec" {
  //   inline = ["echo 'Wait until SSH is ready'"]

  //   connection {
  //     type        = "ssh"
  //     user        = local.ssh_user
  //     private_key = tls_private_key.pmlo-ssh-keys-gen.private_key_pem
  //     host        = self.public_ip
  //     host_key = tls_private_key.pmlo-ssh-keys-gen.public_key_openssh
  //     // host = aws_instance.app_server.public_ip
  //   }
  // }
  tags = {
    Name = "pmlo-test-app-prod"
  }
}


