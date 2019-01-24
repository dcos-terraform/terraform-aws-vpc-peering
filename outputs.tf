locals {
  local_vpc_route_tables  = "${compact(concat(data.aws_route_tables.local_vpc_rts.ids, list("")))}"
  remote_vpc_route_tables = "${compact(concat(data.aws_route_tables.remote_vpc_rts.ids, list("")))}"
}

output "local_vpc_route_tables" {
  description = "Private route tables"
  value       = ["${local.local_vpc_route_tables}"]
}

output "remote_vpc_route_table" {
  description = "Public route tables"
  value       = ["${local.remote_vpc_route_tables}"]
}
