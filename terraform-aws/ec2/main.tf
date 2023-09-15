resource "aws_instance" "linux_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name      = var.key_pair_name
  tags = {
    Name = var.instance_name
  }
}
