data "aws_subnet_ids" "selected" {
  vpc_id = "${var.aws_vpc_id}"

  tags {
    Name        = "${var.project}-${var.env}-public"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Network     = "public"
  }
}

data "aws_route_table" "selected" {
  vpc_id = "${var.aws_vpc_id}"

  tags {
    Name        = "${var.project}-${var.env}-private"
    Project     = "${var.project}"
    Environment = "${var.env}"
  }
}

resource "aws_instance" "bastion" {
  ami                    = "${var.aws_ami}"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  subnet_id              = "${data.aws_subnet_ids.selected.ids[0]}"
  source_dest_check      = false
  user_data              = "${data.template_file.bastion.rendered}"
  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}"
  ]

  lifecycle {
    ignore_changes = [
      "ami",
      "key_name"
    ]
  }

  tags {
    Name        = "${var.project}-${var.env}-bastion"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "bastion"
  }
}

resource "aws_eip" "bastion" {
  vpc      = true
  instance = "${aws_instance.bastion.id}"

  tags {
    Name        = "${var.project}-${var.env}-bastion"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "bastion"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = "${data.aws_route_table.selected.id}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${aws_instance.bastion.id}"
}

data "template_file" "bastion" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    cidr_block = "${var.cidr_block}"
  }
}

resource "aws_security_group" "bastion" {
  description = "Allow SSH traffic from the internet"
  vpc_id      = "${var.aws_vpc_id}"

  tags {
    Name        = "${var.project}-${var.env}-bastion"
    Project     = "${var.project}"
    Environment = "${var.env}"
    Tier        = "bastion"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
