provider "aws" {
  region = var.region
  access_key = module.secret-information.access_key_output
  secret_key = module.secret-information.secret_key_output
}