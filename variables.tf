
variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS region to use"
}

variable "env" {
  type        = string
  default     = "prod"
  description = "Environment we are deploying. can be stg (staging), prod (production)"
}

variable "s3_bucket" {
  type        = string
  default     = "pmlo-test"
  description = "S3 bucket to use to store terraform state and others stuffs"
  sensitive   = true
}

variable "app_count" {
  type        = number
  default     = 2
  description = " Number of application instance to create"
}


// variable "tf_state_path" {
//   type          = string
//   default       = "state/${local.name-prefix}-terraform.tfstate"
//   description   = "Path to store terraform state"
// }

// variable "dynamodb_tf_state_lock" {
//   type          = string
//   default       = "tf-state-${local.name-prefix}-lock"
//   description   = "DynamoDB Terraform State Lock Table"
// }


// variable "aws_key_pair_pmlo_ssh_key_name" {
//     type = string
//     default = "ssh-key-${local.name-prefix}"
//     description = "SSH Key name"
// }

variable "aws_instance_default_ami" {
  type        = string
  default     = "ami-018c1c51c7a13e363"
  description = "Default instance ami. Will match the default one in ap-southeast-1 region"
}

variable "aws_instance_default_type" {
  type        = string
  default     = "t2.micro"
  description = "Default instance type (Default: t2.micro)"
}

variable "aws_instance_app_name_prod" {
  type        = string
  default     = "pmlo-app-prod"
  description = "hostname for application Instances"
}

// variable "pmlo_ssh_key_prod" {
//     type = string
//     description = "SSH Key to accessProd AWS instances"
// }
