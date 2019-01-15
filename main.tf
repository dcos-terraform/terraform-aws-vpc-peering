/**
 * 
 * AWS VPC Peering Connection Module
 * =================================
 * 
 * Terraform module, which creates a peering connection between two VPCs and adds routes to the local VPC.
 * 
 * Usage
 * -----
 * 
 * ### Single Region Peering
 * **Notice**: You need to declare both providers even with single region peering.
 * 
 * ```hc1
 * module "vpc_single_region_peering" {
 *   source = "dcos-terraform/vpc-peering/aws"
 * 
 *   providers = {
 *     aws.this = "aws"
 *     aws.peer = "aws"
 *   }
 *
 *   peer_vpc_id              = "vpc-bbbbbbbb"
 *   peer_cidr_block          = "10.0.0.0/16"
 *   peer_main_route_table_id = "rtb-aaaaaaaa"
 *   peer_security_group_id   = "sg-11111111"
 *   this_cidr_block          = "10.1.0.0/16"
 *   this_main_route_table_id = "rtb-bbbbbbbb"
 *   this_security_group_id   = "sg-00000000"
 *   this_vpc_id              = "vpc-aaaaaaaa"
 *
 *   tags = {
 *     Environment = "prod"
 *   }
 * }
 * ```
 * 
 * ### Cross Region Peering
 * 
 * ```hc1
 * module "vpc_cross_region_peering" {
 *   source = "dcos-terraform/vpc-peering/aws"
 * 
 *   providers = {
 *     aws.this = "aws.src"
 *     aws.peer = "aws.dst"
 *   }
 *
 *   peer_vpc_id              = "vpc-bbbbbbbb"
 *   peer_cidr_block          = "10.0.0.0/16"
 *   peer_main_route_table_id = "rtb-aaaaaaaa"
 *   peer_security_group_id   = "sg-11111111"
 *   this_cidr_block          = "10.1.0.0/16"
 *   this_main_route_table_id = "rtb-bbbbbbbb"
 *   this_security_group_id   = "sg-00000000"
 *   this_vpc_id              = "vpc-aaaaaaaa"
 *
 *   tags = {
 *     Environment = "prod"
 *   }
 * }
 *```
 */

# Providers are required because of cross-region
provider "aws" {
  alias = "this"
}

provider "aws" {
  alias = "peer"
}

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

# Create a route
resource "aws_route" "this_rt" {
  provider                  = "aws.this"
  route_table_id            = "${var.this_main_route_table_id}"
  destination_cidr_block    = "${var.peer_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}

## Create a route
resource "aws_route" "peer_rt" {
  provider                  = "aws.peer"
  route_table_id            = "${var.peer_main_route_table_id}"
  destination_cidr_block    = "${var.this_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}

resource "aws_vpc_peering_connection" "peering" {
  provider    = "aws.this"
  vpc_id      = "${var.this_vpc_id}"
  peer_vpc_id = "${var.peer_vpc_id}"
  peer_region = "${data.aws_region.peer.name}"

  tags = "${merge(var.tags, map("Name", "VPC Peering between default and bursting"))}"
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.peer"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
  auto_accept               = true

  tags = "${merge(var.tags, map("Name", "Accepter"))}"
}

resource "aws_security_group_rule" "this_sg" {
  provider    = "aws.this"
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["${var.peer_cidr_block}"]

  security_group_id = "${var.this_security_group_id}"
}

resource "aws_security_group_rule" "peer_sg" {
  provider    = "aws.peer"
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["${var.this_cidr_block}"]

  security_group_id = "${var.peer_security_group_id}"
}
