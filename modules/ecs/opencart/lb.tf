resource "aws_lb" "pmlo-test-app" {
  name               = "pmlo-test-${var.container_name}-lb-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app.id]
  subnets            = var.aws_public_subnets_ids

  enable_deletion_protection = false

  tags = {
    Environment = var.env
  }
}


resource "aws_lb_target_group" "pmlo-test-app" {
  name     = "lb-target-${var.container_name}-${var.container_port}-${var.env}"
  port     = var.container_port
  protocol = "HTTP"

  vpc_id      = var.aws_vpc_network_id
  target_type = "ip"

  deregistration_delay = 90

  health_check {
    timeout             = 5
    interval            = 30
    path                = "/"
    port                = var.container_port
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  depends_on = [aws_lb.pmlo-test-app]
}


resource "aws_lb_listener" "pmlo-test-app-http" {

  load_balancer_arn = aws_lb.pmlo-test-app.id
  port              = var.container_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.pmlo-test-app.arn
    type             = "forward"
  }
}