variable "local_subnet_range" {
  description = "Local VPC subnet range in CIDR format"
  type        = string
}

variable "local_main_route_table_id" {
  description = "Local main route table ID used to update access to remote network"
  type        = string
  default     = ""
}

variable "remote_subnet_range" {
  description = "Remote VPC subnet range in CIDR format"
  type        = string
}

variable "remote_main_route_table_id" {
  description = "Remote main route table ID used to update access to local network"
  type        = string
  default     = ""
}

variable "remote_vpc_id" {
  description = "Remote VPC ID"
  type        = string
}

variable "local_vpc_id" {
  description = "Local VPC ID"
  type        = string
}

variable "tags" {
  description = "Add custom tags to all resources"
  type        = map(string)
  default     = {}
}

