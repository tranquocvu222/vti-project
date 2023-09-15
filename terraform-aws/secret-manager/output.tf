output "access_key_output" {
  value = jsondecode(data.aws_secretsmanager_secret_version.my_secrets.secret_string)["access_key"]
}

output "secret_key_output" {
  value = jsondecode(data.aws_secretsmanager_secret_version.my_secrets.secret_string)["secret_key"]
}

output "public_key_output" {
  value = jsondecode(data.aws_secretsmanager_secret_version.my_secrets.secret_string)["public_key"]
}