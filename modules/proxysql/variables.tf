variable "aws_vpc_id" {
  description = "Amazon VPC ID"
}

variable "aws_ami" {
  description = "Amazon AMI"
}

variable "aws_key_name" {
  description = "Amazon Key Name"
}

variable "project" {
  description = "Name of global project: zenith, wuaki, ..."
}

variable "env" {
  description = "Name of environment: test, qa, staging, sandbox, production, ..."
}

variable "count" {
  description = "Number of instances for ProxySQL"
}

variable "subnet_ids" {
  description = "List of private subnets."
  type        = "list"
}
