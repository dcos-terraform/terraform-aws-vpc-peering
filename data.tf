data "aws_caller_identity" "current" {}

data "aws_region" "peer" {
  provider = "aws.peer"
}

data "aws_security_group" "this" {
  provider = "aws.this"

  filter {
    name   = "group-name"
    values = ["${var.security_group_filter}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${var.this_vpc_id}"]
  }
}

data "aws_security_group" "peer" {
  provider = "aws.peer"

  filter {
    name   = "group-name"
    values = ["${var.security_group_filter}"]
  }

  filter {
    name   = "vpc-id"
    values = ["${var.peer_vpc_id}"]
  }
}

data "aws_vpc" "this" {
  provider = "aws.this"
  id       = "${var.this_vpc_id}"
}

data "aws_vpc" "peer" {
  provider = "aws.peer"
  id       = "${var.peer_vpc_id}"
}

data "aws_route_tables" "this_vpc_rts" {
  provider = "aws.this"
  vpc_id   = "${var.this_vpc_id}"
}

data "aws_route_tables" "peer_vpc_rts" {
  provider = "aws.peer"
  vpc_id   = "${var.peer_vpc_id}"
}
