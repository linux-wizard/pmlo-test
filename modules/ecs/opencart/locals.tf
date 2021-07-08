locals {
  container_name = "${var.container_name}-${var.env}"
  iam_role_name  = "pmlo-test_ecs_instance_role"
  container_port_s = tostring(var.container_port)
}