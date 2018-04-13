variable "aws_vpc_id" {
  description = "Amazon VPC ID"
}

variable "aws_ami" {
  description = "Amazon AMI"
}

variable "aws_key_name" {
  description = "Amazon Key Name"
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

variable "route_table_id" {
  description = "Private route table for NAT with bastion instance."
}

variable "subnet_ids" {
  description = "List of public subnets."
  type        = "list"
}
