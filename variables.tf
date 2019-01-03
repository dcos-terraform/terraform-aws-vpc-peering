variable "this_cidr_block" {
  description = "This VPC CIDR Block"
  type        = "string"
}

variable "this_main_route_table_id" {
  description = "This main route table ID used to update access to peer network"
  type        = "string"
}

variable "this_security_group_id" {
  description = "This Security Group ID used to update access to peer network"
  type        = "string"
}

variable "peer_cidr_block" {
  description = "Peer VPC CIDR Block"
  type        = "string"
}

variable "peer_main_route_table_id" {
  description = "Peer main route table ID used to update access to this network"
  type        = "string"
}

variable "peer_security_group_id" {
  description = "Peer Security Group ID used to update access to this network"
  type        = "string"
}

variable "peer_vpc_id" {
  description = "Peer VPC ID"
  type        = "string"
}

variable "this_vpc_id" {
  description = "This VPC ID"
  type        = "string"
}

variable "tags" {
  description = "Tags: map"
  type        = "map"
  default     = {}
}
