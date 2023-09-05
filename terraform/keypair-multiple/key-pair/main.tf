resource "aws_key_pair" "key_pair" {
  count = var.enable_provision_key_pair ? 1 : 0
  key_name   = var.key_pair_name
  public_key = var.public_key
}

resource "aws_key_pair" "key_pair_count" {
  count = var.enable_provision_key_pair ? 0 : 1
  key_name = var.key_pair_name
  public_key = var.public_key
}
