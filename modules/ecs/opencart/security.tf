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
    from_port   = 0
    to_port     = var.container_port
    protocol    = var.container_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
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
