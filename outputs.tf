locals {
  this_vpc_route_tables = "${compact(concat(data.aws_route_tables.this_vpc_rts.ids, list("")))}"
  peer_vpc_route_tables = "${compact(concat(data.aws_route_tables.peer_vpc_rts.ids, list("")))}"
}

output "this_vpc_route_tables" {
  description = "Private route tables"
  value       = ["${local.this_vpc_route_tables}"]
}

output "peer_vpc_route_table" {
  description = "Public route tables"
  value       = ["${local.peer_vpc_route_tables}"]
}
