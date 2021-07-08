data "aws_iam_policy_document" "pmlo-test-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "task_permissions" {
  statement {
    actions = [
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:DeregisterContainerInstance",
      "ecs:RegisterContainerInstance",
      "ecs:Submit*",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [aws_cloudwatch_log_group.pmlo-test-app.arn,
    "${aws_cloudwatch_log_group.pmlo-test-app.arn}:*"]
  }

}


resource "aws_iam_role" "pmlo-test-assume" {
  name               = "pmlo-test-assume"
  assume_role_policy = data.aws_iam_policy_document.pmlo-test-assume.json
}


resource "aws_iam_role_policy_attachment" "pmlo-test-assume" {
  role       = aws_iam_role.pmlo-test-assume.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "pmlo-test-ecs_agent" {
  name = "pmlo-test-ecs-agent-agent"
  role = aws_iam_role.pmlo-test-assume.name
}

resource "aws_iam_role" "pmlo-test-ecs_task_role" {
  name               = "pmlo-test-ecs_task_role"
  assume_role_policy = data.aws_iam_policy_document.pmlo-test-assume.json
}


resource "aws_iam_role_policy" "pmlo-test-ecs_task_role_policy" {
  name   = "pmlo-test-ecs_task_role-policy"
  role   = aws_iam_role.pmlo-test-ecs_task_role.id
  policy = data.aws_iam_policy_document.task_permissions.json
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.pmlo-test-ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}