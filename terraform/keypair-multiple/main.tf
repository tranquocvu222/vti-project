module "secret-information" {
  source ="../secret-manager"
  arn_secret_manager = var.arn_secret_manager
  region = var.region
}

module "key_pair" {
  depends_on    = [module.secret-information]
  source        = "./key-pair"
  enable_provision_key_pair = true
  for_each      = var.key_pairs
  key_pair_name = each.value
  public_key    = module.secret-information.public_key_output
}
