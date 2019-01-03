
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

  peer_vpc_id              = "vpc-bbbbbbbb"
  peer_cidr_block          = "10.0.0.0/16"
  peer_main_route_table_id = "rtb-aaaaaaaa"
  peer_security_group_id   = "sg-11111111"
  this_cidr_block          = "10.1.0.0/16"
  this_main_route_table_id = "rtb-bbbbbbbb"
  this_security_group_id   = "sg-00000000"
  this_vpc_id              = "vpc-aaaaaaaa"

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

  peer_vpc_id              = "vpc-bbbbbbbb"
  peer_cidr_block          = "10.0.0.0/16"
  peer_main_route_table_id = "rtb-aaaaaaaa"
  peer_security_group_id   = "sg-11111111"
  this_cidr_block          = "10.1.0.0/16"
  this_main_route_table_id = "rtb-bbbbbbbb"
  this_security_group_id   = "sg-00000000"
  this_vpc_id              = "vpc-aaaaaaaa"

  tags = {
    Environment = "prod"
  }
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| peer_cidr_block | Peer VPC CIDR Block | string | - | yes |
| peer_main_route_table_id | Peer main route table ID used to update access to this network | string | - | yes |
| peer_security_group_id | Peer Security Group ID used to update access to this network | string | - | yes |
| peer_vpc_id | Peer VPC ID | string | - | yes |
| tags | Tags: map | map | `<map>` | no |
| this_cidr_block | This VPC CIDR Block | string | - | yes |
| this_main_route_table_id | This main route table ID used to update access to peer network | string | - | yes |
| this_security_group_id | This Security Group ID used to update access to peer network | string | - | yes |
| this_vpc_id | This VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| peer_vpc_route_table | Public route tables |
| this_vpc_route_tables | Private route tables |

