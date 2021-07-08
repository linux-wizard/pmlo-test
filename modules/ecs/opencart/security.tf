resource "random_password" "pmlo-test-app-passwd-prod" {
  length           = 16
  special          = true
  override_special = "_%@"
}


resource "aws_security_group" "app" {
  name   = "pmlo-test-${var.container_name}-${var.env}"
  vpc_id = var.aws_vpc_network_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = var.container_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = var.container_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }


  // Terraform removes the default ALLOW ALL rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "pmlo-test_app ECS"
  }
}



//   tags = {
//     Name = "pmlo-test_xwiki-lb"
//   }
// }

// data "aws_partition" "current" {}

// resource "aws_iam_role" "pmlo-test-iam" {
//   name = local.iam_role_name
//   path = "/ecs/"

//   //   tags = var.tags

//   assume_role_policy = <<EOF
// {
//   "Version": "2008-10-17",
//   "Statement": [
//     {
//       "Action": "sts:AssumeRole",
//       "Principal": {
//         "Service": ["ec2.amazonaws.com"]
//       },
//       "Effect": "Allow"
//     }
//   ]
// }
// EOF
// }

// resource "aws_iam_instance_profile" "pmlo-test-iam" {
//   name = local.iam_role_name
//   role = aws_iam_role.pmlo-test-iam.name
// }

// resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
//   role       = aws_iam_role.pmlo-test-iam.id
//   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
// }
