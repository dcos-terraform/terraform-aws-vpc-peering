output "local_vpc_route_table" {
  description = "Private route table"
  value       = "${data.aws_vpc.local.main_route_table_id}"
}

output "remote_vpc_route_table" {
  description = "Public route table"
  value       = "${data.aws_vpc.remote.main_route_table_id}"
}
