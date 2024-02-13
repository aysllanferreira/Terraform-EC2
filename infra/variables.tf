variable "aws_region" {
  type = string
}

variable "sshKeys" {
  type = string
}

variable "instance" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "group_name" {
  type = string
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "production" {
  type = bool
}