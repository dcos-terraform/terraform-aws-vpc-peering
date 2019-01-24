
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
    aws.local = "aws"
    aws.remote = "aws"
  }

  remote_vpc_id              = "vpc-bbbbbbbb"
  remote_cidr_block          = "10.0.0.0/16"
  remote_main_route_table_id = "rtb-aaaaaaaa"
  remote_security_group_id   = "sg-11111111"
  local_cidr_block          = "10.1.0.0/16"
  local_main_route_table_id = "rtb-bbbbbbbb"
  local_security_group_id   = "sg-00000000"
  local_vpc_id              = "vpc-aaaaaaaa"

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
    aws.local = "aws.src"
    aws.remote = "aws.dst"
  }

  remote_vpc_id              = "vpc-bbbbbbbb"
  remote_cidr_block          = "10.0.0.0/16"
  remote_main_route_table_id = "rtb-aaaaaaaa"
  remote_security_group_id   = "sg-11111111"
  local_cidr_block          = "10.1.0.0/16"
  local_main_route_table_id = "rtb-bbbbbbbb"
  local_security_group_id   = "sg-00000000"
  local_vpc_id              = "vpc-aaaaaaaa"

  tags = {
    Environment = "prod"
  }
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| local_cidr_block | local VPC CIDR Block | string | - | yes |
| local_main_route_table_id | Local main route table ID used to update access to remote network | string | - | yes |
| local_security_group_id | Local Security Group ID used to update access to remote network | string | - | yes |
| local_vpc_id | Local VPC ID | string | - | yes |
| remote_cidr_block | Remote VPC CIDR Block | string | - | yes |
| remote_main_route_table_id | Remote main route table ID used to update access to local network | string | - | yes |
| remote_security_group_id | Remote Security Group ID used to update access to local network | string | - | yes |
| remote_vpc_id | Remote VPC ID | string | - | yes |
| tags | Tags: map | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| local_vpc_route_tables | Private route tables |
| remote_vpc_route_table | Public route tables |

