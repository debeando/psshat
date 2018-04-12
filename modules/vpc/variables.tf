variable "aws_region" {
  description = "Specify VPC region."
}

variable "aws_az" {
  description = "List of availability zones."
}

variable "cidr_block" {
  description = "Specify a range of IPv4 addresses for the VPC."
}

variable "project" {
  description = "Name of global project: zenith, wuaki, ..."
}

variable "env" {
  description = "Name of environment: test, qa, staging, sandbox, production, ..."
}
