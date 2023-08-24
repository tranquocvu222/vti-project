#The variables have been declared in the variable section of the vti-demo workspace on HashiCorp Cloud
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {

}

variable "PUBLIC_KEY" {}

variable "INSTANCE_NAME" {}

#The local variables
variable "aws_region" {
  description = "aws_region"
}

variable "ami_id" {
  description = "ami_id"
}

variable "instance_type" {
  description = "instance_type"
}

variable "key_pair_name" {
  description = "key_pair_name"
}

variable "security_group_id" {
  description = "security_group_id"
}

