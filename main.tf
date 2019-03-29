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
 *     aws.local = "aws"
 *     aws.remote = "aws"
 *   }
 *
 *   remote_vpc_id       = "vpc-bbbbbbbb"
 *   remote_subnet_range = "10.0.0.0/16"
 *   local_subnet_range  = "10.1.0.0/16"
 *   local_vpc_id        = "vpc-aaaaaaaa"
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
 *     aws.local  = "aws.src"
 *     aws.remote = "aws.dst"
 *   }
 *
 *   remote_vpc_id       = "vpc-bbbbbbbb"
 *   remote_subnet_range = "10.0.0.0/16"
 *   local_subnet_range  = "10.1.0.0/16"
 *   local_vpc_id        = "vpc-aaaaaaaa"
 *
 *   tags = {
 *     Environment = "prod"
 *   }
 * }
 *```
 */

# Providers are required because of cross-region
provider "aws" {
  alias = "local"
}

provider "aws" {
  alias = "remote"
}

data "aws_region" "remote" {
  provider = "aws.remote"
}

data "aws_vpc" "local" {
  provider = "aws.local"
  id       = "${var.local_vpc_id}"
}

data "aws_vpc" "remote" {
  provider = "aws.remote"
  id       = "${var.remote_vpc_id}"
}

# Create a route
resource "aws_route" "local_rt" {
  provider                  = "aws.local"
  route_table_id            = "${coalesce(var.local_main_route_table_id, data.aws_vpc.local.main_route_table_id)}"
  destination_cidr_block    = "${var.remote_subnet_range}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}

## Create a route
resource "aws_route" "remote_rt" {
  provider                  = "aws.remote"
  route_table_id            = "${coalesce(var.remote_main_route_table_id, data.aws_vpc.remote.main_route_table_id)}"
  destination_cidr_block    = "${var.local_subnet_range}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
}

resource "aws_vpc_peering_connection" "peering" {
  provider    = "aws.local"
  vpc_id      = "${var.local_vpc_id}"
  peer_vpc_id = "${var.remote_vpc_id}"
  peer_region = "${data.aws_region.remote.name}"

  tags = "${merge(var.tags, map("Name", "Initiator: VPC Peering between default and remote",
                                "accepter_vpc", var.remote_vpc_id,
                                "initiator_vpc", var.local_vpc_id))}"
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "remote" {
  provider                  = "aws.remote"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
  auto_accept               = true

  tags = "${merge(var.tags, map("Name", "Accepter",
                                "accepter_vpc", var.remote_vpc_id,
                                "initiator_vpc", var.local_vpc_id))}"
}
