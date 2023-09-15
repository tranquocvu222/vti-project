//Get AWS key from secret manager
module "secret-information" {
  source = "./secret-manager"
  arn_secret_manager = var.arn_secret_manager
  region = var.region
}

//Create keypair
module "key_pair" {
  depends_on    = [module.secret-information]
  source        = "./key-pair"
  key_pair_name = local.key_pair_name[terraform.workspace]
  public_key    = module.secret-information.public_key_output
}

//Create VPC
module "vpc" {
  depends_on = [module.secret-information]
  source = "./vpc"
  cidr_block = local.vpc_cidr_block[terraform.workspace]
  vpc_name = local.vpc_name[terraform.workspace]

}

//Create security-group for bastion host
module "security-group-bastion" {
  depends_on = [module.vpc]
  vpc_id = module.vpc.vpc_id
  source = "./security-group"
  sg_name = local.security_group_name_for_bastion[terraform.workspace]
  sg_description = local.security_group_description[terraform.workspace]
  ingress_rules = local.ingress_rule_for_bastion_host[terraform.workspace]
  egress_rules = []
}

//Create security-group for private subnet
module "security-group-private-subnet" {
  depends_on = [
    module.vpc,
    module.security-group-bastion
  ]
  vpc_id = module.vpc.vpc_id
  source = "./security-group"
  sg_name = local.security_group_name_for_private_subnet[terraform.workspace]
  sg_description = local.security_group_description_for_private_subnet[terraform.workspace]
  ingress_rules = local.ingress_rules_for_private_subnet[terraform.workspace]
  egress_rules = []
}

//Create 2 subnet-private AZ#1
module "subnet-private-az1" {
  depends_on = [module.vpc]
  source = "./subnet"
  vpc_id = module.vpc.vpc_id
  count = 2
  cidr_block_subnet = cidrsubnet(local.vpc_cidr_block[terraform.workspace], 4, count.index)
  subnet_name   = "${local.subnet_private_prefix_name[terraform.workspace]} AZ1 ${count.index + 1}"
  subnet_type = "Private"
  availability_zone = var.first_availability_zone
}

//Create 2 subnet-private AZ#2
module "subnet-private-az2" {
  depends_on = [module.vpc]
  source = "./subnet"
  vpc_id = module.vpc.vpc_id
  count = 2
  cidr_block_subnet = cidrsubnet(local.vpc_cidr_block[terraform.workspace], 4, count.index + 2)
  subnet_name   = "${local.subnet_private_prefix_name[terraform.workspace]} AZ2 ${count.index + 1}"
  subnet_type = "Private"
  availability_zone = var.second_availability_zone
}

//Create subnet-public
module "subnet-public-az2" {
  depends_on = [module.vpc]
  source = "./subnet"
  vpc_id = module.vpc.vpc_id
  count = 1
  cidr_block_subnet = cidrsubnet(local.vpc_cidr_block[terraform.workspace], 4, 8)
  subnet_name = "${local.subnet_public_prefix_name[terraform.workspace]} AZ2 ${count.index + 1}"
  subnet_type = "Public"
  availability_zone = var.second_availability_zone
}

//Create bastion_host
module "bastion-host-az2" {
  depends_on = [
    module.key_pair,
    module.vpc,
    module.security-group-bastion,
    module.subnet-public-az2,
  ]
  source = "./ec2"
  ami_id = local.ami_id[terraform.workspace]
  instance_type = local.instance_type[terraform.workspace]
  key_pair_name      = module.key_pair.key_pair_name
  security_group_id = module.security-group-bastion.security_group_id
  subnet_id = module.subnet-public-az2[0].subnet_ids[0]
  instance_name = local.instance_name[terraform.workspace]
}

//Create ECR
module "ecr" {
  source = "./ecr"
  ecr_name = local.ecr_name[terraform.workspace]
}

//Create IAM role
module "iam-role" {
  source = "./iam-role"
  iam_role_name = local.iam_role_name[terraform.workspace]
  assume_role_policy = local.assume_role_policy[terraform.workspace]
}

//Create IAM policy
module "iam-policy" {
  depends_on = [module.ecr]
  source = "./iam-policy"
  policy_name = local.policy_name[terraform.workspace]
  policy_description = local.policy_description[terraform.workspace]
  policy_rule = local.policy_rule[terraform.workspace]
}

//Create IAM role policy attachment
module "iam-role-policy-attachment" {
  depends_on = [
    module.iam-role,
    module.iam-policy
  ]
  source = "./iam-policy_attachment"
  policy_arn = module.iam-policy.iam_policy_arn
  iam_role = module.iam-role.iam_role_name
}

//aws_cluster
module "ecs-cluster" {
  source = "./ecs-cluster"
  cluster_name = local.cluster_name[terraform.workspace]
}

//aws_ecs_task_definition
module "jenkins-task-private-az2" {
  depends_on = [
    module.iam-role-policy-attachment
  ]
  source = "./ecs-task-definition"
  family = local.family[terraform.workspace]
  network_mode = local.network_mode[terraform.workspace]
  iam_role = module.iam-role.iam_role_arn
  task_role = module.iam-role.iam_role_arn
  cpu = local.cpu[terraform.workspace]
  memory = local.memory[terraform.workspace]
  requires_compatibilities = local.requires_compatibilities[terraform.workspace]
  container_definitions = local.container_definitions[terraform.workspace]
}

#aws_ecs_service
module "jenkin-task-service" {
  depends_on = [
    module.ecs-cluster,
    module.jenkins-task-private-az2
  ]
  source = "./ecs-service"
  service_name = local.service_name[terraform.workspace]
  cluster_id = module.ecs-cluster.ecs_cluster_id
  task_arn = module.jenkins-task-private-az2.task-definition-arn
  launch_type = local.launch_type[terraform.workspace]
  subnet_ids = [module.subnet-private-az2[0].subnet_ids[0]]
  security_groups = [module.security-group-private-subnet.security_group_id]
}

#aws_mariadb subnet_group
module "maria-db-subnet-group" {
  depends_on = [
    module.subnet-private-az1,
    module.subnet-private-az2
  ]
  source = "./subnet_group"
  subnet_group_name = local.subnet_group_mariadb_name[terraform.workspace]
  subnet_ids = flatten([
    module.subnet-private-az1[*].subnet_ids,
    module.subnet-private-az2[*].subnet_ids
  ])
}

#aws_postgres subnet_group
module "postgres-db-subnet-group" {
  depends_on = [
    module.subnet-private-az1,
    module.subnet-private-az2
  ]
  source = "./subnet_group"
  subnet_group_name = local.subnet_group_postgres_name[terraform.workspace]
  subnet_ids = flatten([
    module.subnet-private-az1[*].subnet_ids,
    module.subnet-private-az2[*].subnet_ids
  ])
}

#aws_mariadb
module "maria-db" {
  depends_on = [
    module.subnet-private-az1,
    module.maria-db-subnet-group
  ]
  source = "./rds"
  allocated_storage = local.allocated_storage_mariadb[terraform.workspace]
  storage_type = local.storage_type_mariadb[terraform.workspace]
  db_name = local.db_name_mariadb[terraform.workspace]
  engine = local.engine_mariadb[terraform.workspace]
  engine_version = local.engine_version_mariadb[terraform.workspace]
  instance_class = local.instance_class_mariadb[terraform.workspace]
  username = local.username_mariadb[terraform.workspace]
  password = local.password_mariadb[terraform.workspace]
  parameter_group_name = local.parameter_group_name_mariadb[terraform.workspace]
  skip_final_snapshot = local.skip_final_snapshot_mariadb[terraform.workspace]
  vpc_security_group_ids = [module.security-group-private-subnet.security_group_id]
  db_subnet_group_name = module.maria-db-subnet-group.subnet_group_name
}

#aws_postgres
module "postgres-db" {
  depends_on = [
    module.subnet-private-az1,
    module.postgres-db-subnet-group
  ]
  source = "./rds"
  allocated_storage = local.allocated_storage_postgres[terraform.workspace]
  storage_type = local.storage_type_postgres[terraform.workspace]
  db_name = local.db_name_postgres[terraform.workspace]
  engine = local.engine_postgres[terraform.workspace]
  engine_version = local.engine_version_postgres[terraform.workspace]
  instance_class = local.instance_class_postgres[terraform.workspace]
  username = local.username_postgres[terraform.workspace]
  password = local.password_postgres[terraform.workspace]
  parameter_group_name = local.parameter_group_name_postgres[terraform.workspace]
  skip_final_snapshot = local.skip_final_snapshot_postgres[terraform.workspace]
  vpc_security_group_ids = [module.security-group-private-subnet.security_group_id]
  db_subnet_group_name = module.postgres-db-subnet-group.subnet_group_name
}

#system-manager for mariadb
module "ssm-mariadb" {
  depends_on = [module.maria-db]
  source = "./system-manager"
  system_manager_name = local.system_manager_name_mariadb[terraform.workspace]
  system_manager_description = local.description_mariadb[terraform.workspace]
  system_maneger_type = local.system_maneger_type_mariadb[terraform.workspace]
  db_password = module.maria-db.db-instance-password
  environment_tag = terraform.workspace
}

#system-manager for postgres
module "ssm-postgres" {
  depends_on = [module.postgres-db]
  source = "./system-manager"
  system_manager_name = local.system_manager_name_postgres[terraform.workspace]
  system_manager_description = local.description_postgres[terraform.workspace]
  system_maneger_type = local.system_maneger_type_postgres[terraform.workspace]
  db_password = module.postgres-db.db-instance-password
  environment_tag = terraform.workspace
}