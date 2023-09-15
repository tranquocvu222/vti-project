resource "aws_ssm_parameter" "system_manager" {
  name  = var.system_manager_name
  description = var.system_manager_description
  type  = var.system_maneger_type
  value = var.db_password
  tags = {
    environment = var.environment_tag
  }
}