output "local_vpc_route_table" {
  description = "Private route table"
  value       = "${data.aws_route_table.local_vpc_rt.id}"
}

output "remote_vpc_route_table" {
  description = "Public route table"
  value       = "${data.aws_route_table.remote_vpc_rt.id}"
}
