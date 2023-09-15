resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = var.task_arn
  launch_type     = var.launch_type

  network_configuration {
    subnets = var.subnet_ids
    security_groups = var.security_groups
  }
}