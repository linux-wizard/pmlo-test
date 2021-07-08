resource "aws_launch_configuration" "pmlo-test-launch_config" {
  name                 = "pmlo-test-launch_config"
  image_id             = var.aws_instance_default_ami
  iam_instance_profile = aws_iam_instance_profile.pmlo-test-ecs_agent.name
  security_groups      = [aws_security_group.app.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=opencart-prod >> /etc/ecs/ecs.config"
  instance_type        = "t2.micro"
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name                = "pmlo-test-launch_asg"
  vpc_zone_identifier = [var.aws_public_subnets_ids[0], var.aws_public_subnets_ids[1], var.aws_public_subnets_ids[2]]

  launch_configuration = aws_launch_configuration.pmlo-test-launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "EC2"
}