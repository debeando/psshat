output "id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_route_table_id" {
  value = "${aws_route_table.subnet_private.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.subnet_public.*.id[0]}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.subnet_private.*.id[0]}"
}
