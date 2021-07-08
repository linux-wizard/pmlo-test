resource "aws_cloudwatch_log_group" "pmlo-test-app" {
  name              = var.container_name
  retention_in_days = 1

  tags = {
    Environment = var.env
    Application = "PMLO-test App"
  }
}

resource "aws_kms_key" "pmlo-test-app" {
  description             = "${var.container_name}-kms-${var.env}"
  deletion_window_in_days = 7
}

resource "aws_ecs_task_definition" "pmlo-test-app" {
  family                   = var.container_name
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.pmlo-test-ecs_task_role.arn
  execution_role_arn       = aws_iam_role.pmlo-test-assume.arn
  cpu                      = "4096"
  memory                   = "8192"
  requires_compatibilities = ["FARGATE"]

  // https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html
  container_definitions = jsonencode([
    {
      "image" : "docker.io/bitnami/opencart:3",
      "name" : "${var.container_name}",
      "cpu" : 1024,
      "memory" : 1024,
      "portMappings" : [
        {
          "containerPort" : var.container_port,
          "hostPort" : var.container_port
        },
        {
          "containerPort" : 8443,
          "hostPort" : 8443
        }
      ],
      "environment" : [
        {
          "name" : "OPENCART_HOST",
          "value" : "localhost"
        },
        {
          "name" : "OPENCART_DATABASE_HOST",
          "value" : "localhost"
        },
        {
          "name" : "OPENCART_DATABASE_PORT_NUMBER",
          "value" : "3306"
        },
        {
          "name" : "OPENCART_DATABASE_USER",
          "value" : "bn_opencart"
        },
        {
          "name" : "OPENCART_DATABASE_NAME",
          "value" : "bitnami_opencart"
        },
        {
          "name" : "ALLOW_EMPTY_PASSWORD",
          "value" : "yes"
        },
        {
          "name" : "APACHE_HTTP_PORT_NUMBER",
          "value" : local.container_port_s
        }
      ],
      "dependsOn" : [
        {
          "condition" : "START",
          "containerName" : "mariadb"
        }
      ],
      "startTimeout" : 60,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-region" : var.region,
          "awslogs-group" : aws_cloudwatch_log_group.pmlo-test-app.name,
          "awslogs-stream-prefix" : "${var.container_name}-${var.env}"
        }
      }
    },
    {
      "image" : "adminer",
      "name" : "adminer",
      "cpu" : 512,
      "memory" : 1024,
      "portMappings" : [
        {
          "containerPort" : 8080,
          "hostPort" : 8080
        }
      ],
      "startTimeout" : 60,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-region" : var.region,
          "awslogs-group" : aws_cloudwatch_log_group.pmlo-test-app.name,
          "awslogs-stream-prefix" : "adminer-${var.env}"
        }
      }
    },
    {
      "environment" : [
        {
          "name" : "ALLOW_EMPTY_PASSWORD",
          "value" : "yes"
        },
        {
          "name" : "MARIADB_USER",
          "value" : "bn_opencart"
        },
        {
          "name" : "MARIADB_DATABASE",
          "value" : "bitnami_opencart"
        }
      ],
      "essential" : true,
      "image" : "docker.io/bitnami/mariadb:10.3",
      "name" : "mariadb",
      "cpu" : 1024,
      "memory" : 4096,
      "portMappings" : [
        {
          "containerPort" : 3306
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-region" : var.region,
          "awslogs-group" : aws_cloudwatch_log_group.pmlo-test-app.name,
          "awslogs-stream-prefix" : "mariadb-${var.env}"
        }
      }
    }
  ])
}

resource "aws_ecs_cluster" "pmlo-test-app-cluster" {
  name = "${var.container_name}-${var.env}"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.pmlo-test-app.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.pmlo-test-app.name
      }
    }

  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "pmlo-test-app" {
  name            = var.container_name
  cluster         = aws_ecs_cluster.pmlo-test-app-cluster.id
  task_definition = aws_ecs_task_definition.pmlo-test-app.arn
  // iam_role        = aws_iam_role.pmlo-test-assume.arn
  launch_type   = "FARGATE"
  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = var.aws_private_subnets_ids
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = true
  }


  load_balancer {
    container_name   = var.container_name
    target_group_arn = aws_lb_target_group.pmlo-test-app.arn
    container_port   = var.container_port
  }
  depends_on = [
    aws_ecs_task_definition.pmlo-test-app,
    aws_lb.pmlo-test-app
  ]

  // lifecycle {
  //   ignore_changes = [task_definition, desired_count]
  // }
  //   depends_on = [
  //     aws_ecs_task_definition.xwiki,
  //     aws_iam_instance_profile.pmlo-test-iam
  //   ]
}

// resource "aws_ecr_repository" "worker" {
//     name  = "worker"
// }