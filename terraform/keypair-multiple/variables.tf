variable "key_pairs" {
  type = set(string)
  default = ["keypair_vutq2_1", "keypair_vutq2_2", "keypair_vutq2_3"]
}

variable "region" {
  type = string
  default = "ap-southeast-2"
}

variable "arn_secret_manager" {
  type = string
}


variable "key_pair_name" {
  type = string
  default = "vutq-keypair"
}
