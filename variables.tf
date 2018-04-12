variable "aws_region" {
  description = "AWS Region."
  type        = "string"
}

variable "aws_az" {
  description = "List of availability zones."
  type        = "string"
  default     = "a,b,c"
}

variable "aws_ami" {
  description = "Amazon AMI"
  type        = "string"
  default     = "ami-ac442ac3"
}

variable "aws_key_name" {
  description = "Amazon Key Name"
  type        = "string"
}

variable "cidr_block" {
  description = "Specify a range of IPv4 addresses for the VPC."
  type        = "string"
  default     = "10.24.0.0/16"
}

variable "project" {
  description = "Name of global project: foo, bar, ..."
  type        = "string"
}

variable "env" {
  description = "Name of environment: test, qa, staging, sandbox, production, ..."
  type        = "string"
}

variable "proxysql_count" {
  description = "Number of instances for ProxySQL"
  type        = "string"
  default     = "1"
}
