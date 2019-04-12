
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
| local\_subnet\_range | Local VPC subnet range in CIDR format | string | n/a | yes |
| local\_vpc\_id | Local VPC ID | string | n/a | yes |
| remote\_subnet\_range | Remote VPC subnet range in CIDR format | string | n/a | yes |
| remote\_vpc\_id | Remote VPC ID | string | n/a | yes |
| local\_main\_route\_table\_id | Local main route table ID used to update access to remote network | string | `""` | no |
| remote\_main\_route\_table\_id | Remote main route table ID used to update access to local network | string | `""` | no |
| tags | Add custom tags to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| local\_vpc\_route\_table | Private route table |
| remote\_vpc\_route\_table | Public route table |

