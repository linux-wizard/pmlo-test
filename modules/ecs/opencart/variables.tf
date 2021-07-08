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

variable "aws_vpc_network_id" {
  description = "VPC Network ID"
  type        = string
  default     = ""
}


variable "rds_engine_version" {
  type        = string
  description = "RDS engine version"
}

variable "rds_endpoint" {
  type        = string
  description = "RDS endpoint to use"
}

variable "rds_username" {
  type        = string
  description = "RDS root username"
}

variable "rds_password" {
  type        = string
  description = "RDS root password"
}

variable "rds_database" {
  type        = string
  default     = "postgres"
  description = "RDS database"
}

variable "app_user" {
  type        = string
  default     = "app-user"
  description = "Application user"
}

variable "container_port" {
  type        = number
  default     = 8081
  description = "Container port"
}

variable "container_name" {
  type        = string
  default     = "test-app"
  description = "Container application name"
}

variable "container_protocol" {
  type        = string
  default     = "tcp"
  description = "Container protocol"
}

variable "network_vpc_subnets" {
  description = "List of VPC subnets"
  type        = list(string)
  default     = []
}

variable "network_aws_subnet_app_subnet_ids" {
  description = "List of App subnet IDs"
  type        = list(string)
  default     = []
}

variable "aws_public_subnets_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = []
}

variable "aws_private_subnets_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "aws_instance_default_ami" {
  description = "default AMI"
  type        = string
  default     = "ami-039ec8fc674496137"
}
