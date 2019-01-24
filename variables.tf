variable "local_cidr_block" {
  description = "local VPC CIDR Block"
  type        = "string"
}

variable "local_main_route_table_id" {
  description = "Local main route table ID used to update access to remote network"
  type        = "string"
}

variable "local_security_group_id" {
  description = "Local Security Group ID used to update access to remote network"
  type        = "string"
}

variable "remote_cidr_block" {
  description = "Remote VPC CIDR Block"
  type        = "string"
}

variable "remote_main_route_table_id" {
  description = "Remote main route table ID used to update access to local network"
  type        = "string"
}

variable "remote_security_group_id" {
  description = "Remote Security Group ID used to update access to local network"
  type        = "string"
}

variable "remote_vpc_id" {
  description = "Remote VPC ID"
  type        = "string"
}

variable "local_vpc_id" {
  description = "Local VPC ID"
  type        = "string"
}

variable "tags" {
  description = "Add custom tags to all resources"
  type        = "map"
  default     = {}
}
