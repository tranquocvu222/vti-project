variable "region" {
  type = string
  default = "ap-northeast-3"
}

variable "first_availability_zone" {
  type = string
  default = "ap-northeast-3a"
}

variable "second_availability_zone" {
  type = string
  default = "ap-northeast-3b"
}

variable "arn_secret_manager" {
  type = string
}

locals {

  //VPC variables
  vpc_cidr_block = {
    "develop" = "10.1.0.0/16"
    "staging" = "10.2.0.0/16"
  }

  vpc_name = {
    "develop" = "vpc-dev-vutq"
    "staging" = "vpc-staging-vutq"
  }

  // Subnet variables
  subnet_public_prefix_name = {
    "develop" = "dev-subnet-public-vutq"
    "staging" = "staging-subnet-public-vutq"
  }

  subnet_private_prefix_name = {
    "develop" = "dev-subnet-private-vutq"
    "staging" = "staging-subnet-private -vutq"
  }

  //Keypair variables
  key_pair_name = {
    "develop" = "dev-key-pair-vutq"
    "staging" = "staging-key-pair-vutq"
  }

  //Security group variables for bastion host
  security_group_name_for_bastion =  {
    "develop" = "dev-sg-bastion-host"
    "staging" = "staging-sg-bastion-host"
  }

  security_group_description =  {
    "develop" = "manage network for bastion host in develop env"
    "staging" = "manage network for bastion host in staging env"
  }

  ingress_rule_for_bastion_host = {
    "develop" = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] //change to my ip
        ipv6_cidr_blocks = []
        security_groups = []
      }
    ],
    "staging" = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] //change to my ip
        ipv6_cidr_blocks = []
        security_groups = []
      }
    ]
  }

  //Security group variables for private subnet
  security_group_name_for_private_subnet =  {
    "develop" = "dev-sg-private-subnet"
    "staging" = "staging-sg-private-subnet"
  }

  security_group_description_for_private_subnet =  {
    "develop" = "manage network for private subnet in develop env"
    "staging" = "manage network for private subnet in staging env"
  }

  ingress_rules_for_private_subnet = {
    "develop" = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [] //change to private ip has permission to access private subnet
        ipv6_cidr_blocks = []
        security_groups = [module.security-group-bastion.security_group_id]
      }
    ],
    "staging" = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [] //change to private ip has permission to access private subnet
        ipv6_cidr_blocks = []
        security_groups = [module.security-group-bastion.security_group_id]
      }
    ]
  }

  //Bastion variable
  ami_id = {
    "develop" = "ami-0e2cf9eb313b07049"
    "staging" = "ami-0e2cf9eb313b07049"
  }

  instance_type = {
    "develop" = "t3.small"
    "staging" = "t3.small"
  }

  instance_name = {
    "develop" = "dev-bastion-host-vutq"
    "staging" = "staging-bastion-host-vutq"
  }

  //ECR variables
  ecr_name = {
    "develop" = "dev-ecr-vutq"
    "staging" = "staging-ecr-vutq"
  }

  //IAM variables for ecr and ecs
  iam_role_name = {
    "develop" = "dev-ecs-task-execution-role-vutq"
    "staging" = "staging-ecs-task-execution-role-vutq"
  }

  assume_role_policy = {
    "develop" = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Effect = "Allow",
          Principal = {
            Service = "ecs-tasks.amazonaws.com",
          },
        },
      ],
    })
    "staging" = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Effect = "Allow",
          Principal = {
            Service = "ecs-tasks.amazonaws.com",
          },
        },
      ],
    })
  }

  //Create IAM policy variables
  policy_name = {
    "develop" = "dev-ecr-policy-vutq"
    "staging" = "staging-ecr-policy-vutq"
  }

  policy_description = {
    "develop" = "Policy for ECS instances to access ECR for develop env"
    "staging" = "Policy for ECS instances to access ECR for staging env"
  }

  policy_rule = {
    "develop" = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetAuthorizationToken",
            "ecr:GetRepositoryPolicy",
            "ecr:ListImages",
            "ecr:DescribeRepositories",
            "ecr:GetRepositoryPolicy",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
          ],
          Effect = "Allow",
          Resource = module.ecr.ecr_repository_arn
        },
      ],
    })
    "staging" = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetAuthorizationToken",
            "ecr:GetRepositoryPolicy",
            "ecr:ListImages",
            "ecr:DescribeRepositories",
            "ecr:GetRepositoryPolicy",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
          ],
          Effect = "Allow",
          Resource = module.ecr.ecr_repository_arn
        },
      ],
    })
  }

  //ECS variables
  cluster_name = {
    "develop" = "dev-ecs-cluster-vutq"
    "staging" = "staging-ecr-cluster-vutq"
  }

  //Task-definition
  family = {
    "develop" = "dev-jenkins-task"
    "staging" = "staging-jenkins-task"
  }

  network_mode = {
    "develop" = "awsvpc"
    "staging" = "awsvpc"
  }

  requires_compatibilities = {
    "develop" = ["FARGATE"]
    "staging" = ["FARGATE"]
  }

  cpu = {
    "develop" = "256"
    "staging" = "256"
  }

  memory = {
    "develop" = "512"
    "staging" = "512"
  }

  container_definitions = {
    "develop" = jsonencode([
      {
        name  = "jenkins-container"
        image = "jenkins/jenkins:latest"
        portMappings = [
          {
            containerPort = 8080
            hostPort      = 8080
          },
        ]
      },
    ])

    "staging" = jsonencode([
      {
        name  = "jenkins-container"
        image = "jenkins/jenkins:latest"
        portMappings = [
          {
            containerPort = 8080
            hostPort      = 8080
          },
        ]
      },
    ])
  }

  //ECS service variables
  service_name = {
    "develop" = "dev-jenkin-service-vutq"
    "staging" = "staging-jenkin-service-vutq"
  }

  launch_type = {
    "develop" = "FARGATE"
    "staging" = "FARGATE"
  }

  //RDS mariaDb variables
  allocated_storage_mariadb = {
    "develop" = 20
    "staging" = 20
  }

  storage_type_mariadb = {
    "develop" = "gp2"
    "staging" = "gp2"
  }

  db_name_mariadb = {
    "develop" = "devMariadbVutq"
    "staging" = "stagingMariadbVutq"
  }

  engine_mariadb = {
    "develop" = "mariadb"
    "staging" = "mariadb"
  }

  engine_version_mariadb = {
    "develop" = "10.6.8"
    "staging" = "10.6.8"
  }

  instance_class_mariadb = {
    "develop" = "db.t3.micro"
    "staging" = "db.t3.micro"
  }

  username_mariadb = {
    "develop" = "devMariadbVutq"
    "staging" = "stagingMariadbVutq"
  }

  password_mariadb = {
    "develop" = "dev-mariadb-${random_string.password.result}"
    "staging" = "staging-mariadb-${random_string.password.result}"
  }

  parameter_group_name_mariadb = {
    "develop" = "default.mariadb10.6"
    "staging" = "default.mariadb10.6"
  }

  skip_final_snapshot_mariadb = {
    "develop" = true
    "staging" = true
  }

  //RDS postgres variables
  allocated_storage_postgres = {
    "develop" = 20
    "staging" = 20
  }

  storage_type_postgres = {
    "develop" = "gp2"
    "staging" = "gp2"
  }

  db_name_postgres = {
    "develop" = "devPostgresVutq"
    "staging" = "stagingPostgresVutq"
  }

  engine_postgres = {
    "develop" = "postgres"
    "staging" = "postgres"
  }

  engine_version_postgres = {
    "develop" = "15.3"
    "staging" = "15.3"
  }

  instance_class_postgres = {
    "develop" = "db.t3.micro"
    "staging" = "db.t3.micro"
  }

  username_postgres = {
    "develop" = "devDB"
    "staging" = "stagingDb"
  }

  password_postgres = {
    "develop" = "dev-postgres-${random_string.password.result}"
    "staging" = "staging-postgres-${random_string.password.result}"
  }

  parameter_group_name_postgres = {
    "develop" = "default.postgres15"
    "staging" = "default.postgres15"
  }

  skip_final_snapshot_postgres = {
    "develop" = true
    "staging" = true
  }

  //System-manager for mariadb
  system_manager_name_mariadb = {
    "develop" = "/develop/database/mariadb/password"
    "staging" = "/staging/database/mariadb/password"
  }

  description_mariadb = {
    "develop" = "MariaDB password for develop env"
    "staging" = "MariaDB password for staging env"
  }

  system_maneger_type_mariadb = {
    "develop" = "SecureString"
    "staging" = "SecureString"
  }

  //System-manager for postgres
  system_manager_name_postgres = {
    "develop" = "/develop/database/postgres/password"
    "staging" = "/staging/database/postgres/password"
  }

  description_postgres  = {
    "develop" = "Postgres password for develop env"
    "staging" = "Postgres password for staging env"
  }

  system_maneger_type_postgres = {
    "develop" = "SecureString"
    "staging" = "SecureString"
  }

  #mariadb subnetgroup
  subnet_group_mariadb_name = {
    "develop" = "dev-mariadb-subnet-group"
    "staging" = "staging-mariadb-subnet-group"
  }

  #postgres subnetgroup
  subnet_group_postgres_name = {
    "develop" = "dev-postgres-subnet-group"
    "staging" = "staging-postgres-subnet-group"
  }

}

resource "random_string" "password" {
  length  = 5
  special = false
  upper   = false
  numeric  = true
}
