AWS VPC Peering Connection Module
=================================

Terraform module, which creates a peering connection between two VPCs and adds routes to the local VPC.

Usage
-----

### Single Region Peering
**Notice**: You need to declare both providers even with single region peering.

```hc1
module "vpc_single_region_peering" {
  source = "dcos-terraform/vpc-peering/aws"

  providers = {
    aws.this = "aws"
    aws.peer = "aws"
  }

  peer_region             = "eu-west-1"
  this_vpc_id             = "vpc-aaaaaaaa"
  peer_vpc_id             = "vpc-bbbbbbbb"

  tags = {
    Environment = "prod"
  }
}
```

### Cross Region Peering

```hc1
module "vpc_cross_region_peering" {
  source = "dcos-terraform/vpc-peering/aws"

  providers = {
    aws.this = "aws.src"
    aws.peer = "aws.dst"
  }

  peer_region             = "us-east-1"
  this_vpc_id             = "vpc-aaaaaaaa"
  peer_vpc_id             = "vpc-bbbbbbbb"

  tags = {
    Environment = "prod"
  }
}
```

License
-------
Apache 2 Licensed. See LICENSE for full details.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| owner_account_id | AWS owner account ID: string | string | `` | no |
| peer_region | Peer Region Name e.g. us-east-1: string | string | `` | no |
| peer_vpc_id | Peer VPC ID: string | string | `` | no |
| peering_id | Provide already existing peering connection id | string | `` | no |
| security_group_filter | Filter to find the cluster internal security group to authorize cidr_block access | string | `<list>` | no |
| tags | Tags: map | map | `<map>` | no |
| this_vpc_id | This VPC ID: string | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| peer_vpc_route_table | Public route tables |
| this_vpc_route_tables | Private route tables |
| vpc_peering_accept_status | Accept status for the connection |
| vpc_peering_id | Peering connection ID |

