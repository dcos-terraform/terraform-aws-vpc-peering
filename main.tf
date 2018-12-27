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
 *   peer_region             = "eu-west-1"
 *   this_vpc_id             = "vpc-aaaaaaaa"
 *   peer_vpc_id             = "vpc-bbbbbbbb"
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
 *   peer_region             = "us-east-1"
 *   this_vpc_id             = "vpc-aaaaaaaa"
 *   peer_vpc_id             = "vpc-bbbbbbbb"
 * 
 *   tags = {
 *     Environment = "prod"
 *   }
 * }
 */

# Providers are required because of cross-region
provider "aws" {
  alias = "this"
}

provider "aws" {
  alias = "peer"
}

# Create a route
resource "aws_route" "this_rt" {
  provider                  = "aws.this"
  route_table_id            = "${data.aws_vpc.this.main_route_table_id}"
  destination_cidr_block    = "${data.aws_vpc.peer.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}

## Create a route
resource "aws_route" "peer_rt" {
  provider                  = "aws.peer"
  route_table_id            = "${data.aws_vpc.peer.main_route_table_id}"
  destination_cidr_block    = "${data.aws_vpc.this.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}

resource "aws_vpc_peering_connection" "peering" {
  provider    = "aws.this"
  vpc_id      = "${data.aws_vpc.this.id}"
  peer_vpc_id = "${data.aws_vpc.peer.id}"
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
  cidr_blocks = ["${data.aws_vpc.peer.cidr_block}"]

  security_group_id = "${data.aws_security_group.this.id}"
}

resource "aws_security_group_rule" "peer_sg" {
  provider    = "aws.peer"
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["${data.aws_vpc.this.cidr_block}"]

  security_group_id = "${data.aws_security_group.peer.id}"
}
