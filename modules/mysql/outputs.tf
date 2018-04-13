output "ips" {
  value = "${join(",",aws_instance.mysql.*.private_ip)}"
}
