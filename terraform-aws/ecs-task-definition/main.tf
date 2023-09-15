resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = var.family
  network_mode          = var.network_mode
  execution_role_arn    = var.iam_role
  task_role_arn         = var.task_role
  requires_compatibilities = var.requires_compatibilities
  cpu = var.cpu
  memory = var.memory
  container_definitions = var.container_definitions
}