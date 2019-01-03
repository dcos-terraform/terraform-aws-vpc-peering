data "aws_caller_identity" "current" {}

data "aws_region" "peer" {
  provider = "aws.peer"
}

data "aws_route_tables" "this_vpc_rts" {
  provider = "aws.this"
  vpc_id   = "${var.this_vpc_id}"
}

data "aws_route_tables" "peer_vpc_rts" {
  provider = "aws.peer"
  vpc_id   = "${var.peer_vpc_id}"
}
