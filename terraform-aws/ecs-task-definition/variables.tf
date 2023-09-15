variable "family" {
  type = string
}

variable "network_mode" {
  type = string
}

variable "iam_role" {
  type = string
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "task_role" {
  type = string
}

variable "container_definitions" {
  type = string
}

variable "requires_compatibilities" {
  type = list(string)
}

