variable "region" {
  type = string
  default = "ap-southeast-2"
}

variable "arn_secret_manager" {
  type = string
}


# variable for vpc
variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  default = "vutq-vpc"
}


# variable for subnet
variable "subnet_cidrs" {
  type    = set(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "subnet_names" {
  type    = set(string)
  default = ["subnet-be", "subnet-rds", "subnet-fe"]
}

# variable for security-group
variable "security_group_names" {
  type    = set(string)
  default = ["sg-be", "sg-rds", "sg-fe"]
}

variable "security_group_descriptions" {
  type    = list(string)
  default = ["manage network for backend", "manage network for database", "manage network for front-end"]
}

variable "ingress_rule_list" {
  type = list(list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
  })))
  default = [
    #inbound for BE
    [
      #SSH at port 22 from my ip
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["113.174.175.110/32"] #my-ip
        ipv6_cidr_blocks = []
      },

      # allows http request
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
      },

      # allows https request
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
      }
    ],

    #inbound for rds
    [
      {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        //ip
        cidr_blocks = ["13.236.162.12/32"] #public-ip of be-ec2-instance
        ipv6_cidr_blocks = []
      }
    ],

    #inbound for FE
    [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # For example purposes, allow all IPs
        ipv6_cidr_blocks = []
      }
    ]
  ]
}

variable "egress_rule_list" {
  type = list(list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
  })))
  default = [
    #outbound for be
    [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
      }
    ],

    #outbound for rds (rds don't have outbound)
    [
    ],

    #outboud for fe
    [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
      }
    ]
  ]
}

locals {
  subnet_name_list = tolist(var.subnet_names)
  subnet_cidr_list = tolist(var.subnet_cidrs)
  sg_name_list = tolist(var.security_group_names)
}
