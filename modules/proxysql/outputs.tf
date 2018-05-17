output "ips" {
  value = "${join(",",aws_instance.proxysql.*.private_ip)}"
}

output "nlb" {
  value = "${aws_lb.proxysql.dns_name}"
}
