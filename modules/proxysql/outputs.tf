output "ips" {
  value = "${join(",",aws_instance.proxysql.*.private_ip)}"
}
