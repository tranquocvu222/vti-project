resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}