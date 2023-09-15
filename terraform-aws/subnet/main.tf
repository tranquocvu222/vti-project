resource "aws_subnet" "vti-subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_subnet
  availability_zone = var.availability_zone
  tags = {
    Name = var.subnet_name
    Type = var.subnet_type
    AvailabilityZone = var.availability_zone
  }
}
