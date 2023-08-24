resource "aws_instance" "linux_ec2_instance" {
  ami           = var.ami_id  # Amazon Linux 2 AMI
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = var.INSTANCE_NAME
  }
}
