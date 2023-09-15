resource "aws_vpc" "vti-vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}