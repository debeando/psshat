terraform {
  required_version = ">= 0.11.3"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  version    = "0.0.1"
  source     = "modules/vpc"
  aws_region = "${var.aws_region}"
  aws_az     = "${var.aws_az}"
  cidr_block = "${var.cidr_block}"
  project    = "${var.project}"
  env        = "${var.env}"
}

module "bastion" {
  version        = "0.0.1"
  source         = "modules/bastion"
  aws_vpc_id     = "${module.vpc.id}"
  aws_ami        = "${var.aws_ami}"
  aws_key_name   = "${var.aws_key_name}"
  cidr_block     = "${var.cidr_block}"
  project        = "${var.project}"
  env            = "${var.env}"
  route_table_id = "${module.vpc.private_route_table_id}"
  subnet_ids     = ["${module.vpc.public_subnet_ids}"]
}

module "proxysql" {
  version      = "0.0.1"
  source       = "modules/proxysql"
  aws_vpc_id   = "${module.vpc.id}"
  aws_ami      = "${var.aws_ami}"
  aws_key_name = "${var.aws_key_name}"
  project      = "${var.project}"
  env          = "${var.env}"
  count        = "${var.proxysql_count}"
  subnet_ids   = ["${module.vpc.private_subnet_ids}"]
}

module "mysql" {
  version      = "0.0.1"
  source       = "modules/mysql"
  aws_vpc_id   = "${module.vpc.id}"
  aws_ami      = "${var.aws_ami}"
  aws_key_name = "${var.aws_key_name}"
  project      = "${var.project}"
  env          = "${var.env}"
  count        = "${var.mysql_count}"
  subnet_ids   = ["${module.vpc.private_subnet_ids}"]
}
