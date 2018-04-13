resource "aws_instance" "mysql" {
  count                  = "${var.count}"
  ami                    = "${var.aws_ami}"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  user_data              = "${data.template_file.mysql.rendered}"
  subnet_id              = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.mysql.id}"
  ]
  tags {
    Name        = "${var.project}-${var.env}-mysql-node${format("%02d", count.index + 1)}"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "mysql"
    Role        = "node"
    Number      = "${count.index + 1}"
  }
  lifecycle {
    ignore_changes = ["ami"]
  }
}

data "template_file" "mysql" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "mysql"
    Role        = "node"
  }
}

resource "aws_security_group" "mysql" {
  description = "Allow SSH & MySQL traffic from VPC"
  vpc_id      = "${var.aws_vpc_id}"

  tags {
    Name        = "${var.project}-${var.env}-mysql"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "mysql"
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
