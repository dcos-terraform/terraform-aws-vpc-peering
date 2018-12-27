variable "owner_account_id" {
  description = "AWS owner account ID: string"
  default     = ""
}

variable "peer_vpc_id" {
  description = "Peer VPC ID: string"
  default     = ""
}

variable "this_vpc_id" {
  description = "This VPC ID: string"
  default     = ""
}

variable "peer_region" {
  description = "Peer Region Name e.g. us-east-1: string"
  default     = ""
}

variable "peering_id" {
  description = "Provide already existing peering connection id"
  default     = ""
}

variable "security_group_filter" {
  description = "Filter to find the cluster internal security group to authorize cidr_block access"
  default     = ["*internal-firewall*"]
}

variable "tags" {
  description = "Tags: map"
  type        = "map"
  default     = {}
}
