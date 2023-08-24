#instance_id
output "instance_id" {
  value = aws_instance.linux_ec2_instance.id
}

# instance_arn
output "instance_arn" {
  value = aws_instance.linux_ec2_instance.arn
}