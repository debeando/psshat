resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name        = "${var.project}-${var.env}"
    Project     = "${var.project}"
    Environment = "${var.env}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.project}-${var.env}"
    Project     = "${var.project}"
    Environment = "${var.env}"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.project}-${var.env}-default"
    Project     = "${var.project}"
    Environment = "${var.env}"
  }
}

resource "aws_subnet" "subnet_public" {
  count             = "${length(split(",", var.aws_az))}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(var.cidr_block, 6, count.index)}"
  availability_zone = "${var.aws_region}${element(split(",", var.aws_az), count.index)}"

  tags {
    Name        = "${var.project}-${var.env}-public"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Network     = "public"
  }
}

resource "aws_subnet" "subnet_private" {
  count             = "${length(split(",", var.aws_az))}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(var.cidr_block, 4, count.index + 1)}"
  availability_zone = "${var.aws_region}${element(split(",", var.aws_az), count.index)}"

  tags {
    Name        = "${var.project}-${var.env}-private"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Network     = "private"
  }
}

resource "aws_default_route_table" "subnet_public" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name        = "${var.project}-${var.env}-public"
    Project     = "${var.project}"
    Environment = "${var.env}"
  }
}

resource "aws_route_table" "subnet_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.project}-${var.env}-private"
    Project     = "${var.project}"
    Environment = "${var.env}"
  }
}

resource "aws_route_table_association" "subnet_public" {
  count          = "${length(split(",", var.aws_az))}"
  subnet_id      = "${element(aws_subnet.subnet_public.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.subnet_public.id}"
}

resource "aws_route_table_association" "subnet_private" {
  count          = "${length(split(",", var.aws_az))}"
  subnet_id      = "${element(aws_subnet.subnet_private.*.id, count.index)}"
  route_table_id = "${aws_route_table.subnet_private.id}"
}
