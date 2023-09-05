module "secret-information" {
  source = "../secret-manager"
  arn_secret_manager = var.arn_secret_manager
  region = var.region
}

module "vpc" {
  depends_on = [module.secret-information]
  source = "./vpc-module/vpc"
  cidr_block = var.vpc_cidr_block
  vpc_name = var.vpc_name
}

module "subnet" {
  depends_on = [module.vpc]
  source = "./vpc-module/subnet"
  vpc_id = module.vpc.vpc_id
  count = length(var.subnet_cidrs)
  cidr_block_subnet = local.subnet_cidr_list[count.index]
  subnet_name = "${var.vpc_name}-${local.subnet_name_list[count.index]}"
}

module "security-group" {
  depends_on = [module.vpc]
  vpc_id = module.vpc.vpc_id
  source = "./vpc-module/sg"
  count = length(var.security_group_names)
  sg_name = "${var.vpc_name}-${local.sg_name_list[count.index]}"
  sg_description = var.security_group_descriptions[count.index]
  ingress_rules = var.ingress_rule_list[count.index]
  egress_rules = var.egress_rule_list[count.index]
}