data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "pmlo-only-my_public_ip" {
  name        = "allow-my_public_ip"
  description = "Allow SSH/http traffic only for my public IP"
  vpc_id      = aws_vpc.pmlo-test-private-network-prod.id

  // SSH access
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [
      "${local.my_public_ip}/32"
    ]
  }

  // App access
  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = [
      "${local.my_public_ip}/32"
    ]
  }

  // Terraform removes the default ALLOW ALL rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}