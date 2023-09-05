data "aws_secretsmanager_secret_version" "my_secrets" {
  secret_id = var.arn_secret_manager
}
