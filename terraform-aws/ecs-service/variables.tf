variable "service_name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "task_arn" {
  type = string
}

variable "launch_type" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

