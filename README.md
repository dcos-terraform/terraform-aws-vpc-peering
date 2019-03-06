
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

  remote_vpc_id       = "vpc-bbbbbbbb"
  remote_subnet_range = "10.0.0.0/16"
  local_subnet_range  = "10.1.0.0/16"
  local_vpc_id        = "vpc-aaaaaaaa"

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
    aws.local  = "aws.src"
    aws.remote = "aws.dst"
  }

  remote_vpc_id       = "vpc-bbbbbbbb"
  remote_subnet_range = "10.0.0.0/16"
  local_subnet_range  = "10.1.0.0/16"
  local_vpc_id        = "vpc-aaaaaaaa"

  tags = {
    Environment = "prod"
  }
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| local_main_route_table_id | Local main route table ID used to update access to remote network | string | `` | no |
| local_subnet_range | Local VPC subnet range in CIDR format | string | - | yes |
| local_vpc_id | Local VPC ID | string | - | yes |
| remote_main_route_table_id | Remote main route table ID used to update access to local network | string | `` | no |
| remote_subnet_range | Remote VPC subnet range in CIDR format | string | - | yes |
| remote_vpc_id | Remote VPC ID | string | - | yes |
| tags | Add custom tags to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| local_vpc_route_table | Private route table |
| remote_vpc_route_table | Public route table |

