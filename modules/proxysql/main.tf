resource "aws_instance" "proxysql" {
  count                  = "${var.count}"
  ami                    = "${var.aws_ami}"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  user_data              = "${data.template_file.proxysql.rendered}"
  subnet_id              = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.proxysql.id}"
  ]
  tags {
    Name        = "${var.project}-${var.env}-proxysql-node${format("%02d", count.index + 1)}"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "proxysql"
    Role        = "node"
    Number      = "${count.index + 1}"
  }
  lifecycle {
    ignore_changes = ["ami"]
  }
}

data "template_file" "proxysql" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "proxysql"
    Role        = "node"
  }
}

resource "aws_security_group" "proxysql" {
  description = "Allow SSH & MySQL traffic from VPC"
  vpc_id      = "${var.aws_vpc_id}"

  tags {
    Name        = "${var.project}-${var.env}-proxysql"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "proxysql"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.24.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "proxysql" {
  name                       = "${var.project}-${var.env}-proxysql"
  internal                   = true
  enable_deletion_protection = false
  load_balancer_type         = "network"
  subnets                    = ["${var.subnet_ids}"]

  tags {
    Name        = "${var.project}-${var.env}-proxysql"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "proxysql"
  }
}

resource "aws_lb_target_group" "proxysql" {
  name     = "${var.project}-${var.env}-proxysql"
  port     = 3306
  protocol = "TCP"
  vpc_id   = "${var.aws_vpc_id}"
}

resource "aws_lb_listener" "proxysql" {
  load_balancer_arn = "${aws_lb.proxysql.arn}"
  port              = "3306"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.proxysql.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "proxysql" {
  count            = "${var.count}"
  target_group_arn = "${aws_lb_target_group.proxysql.arn}"
  target_id        = "${element(aws_instance.proxysql.*.id, count.index)}"
  port             = 3306
}
