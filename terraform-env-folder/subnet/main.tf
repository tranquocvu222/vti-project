resource "aws_subnet" "vti-subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_subnet
  tags = {
    Name = var.subnet_name
    Type = var.subnet_type
  }
}
