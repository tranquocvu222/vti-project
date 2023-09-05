variable "ingress_rules" {
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "List of egress rules"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    ipv6_cidr_blocks = list(string)
  }))
}

variable "vpc_id" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}