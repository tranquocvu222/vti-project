output "subnet_ids" {
  value = aws_subnet.vti-subnet[*].id
}