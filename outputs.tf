output "bastion_public_ip" {
  value = "${module.bastion.public_ip}"
}

output "mysql_ips" {
  value = "${module.mysql.ips}"
}

output "proxysql_ips" {
  value = "${module.proxysql.ips}"
}

output "proxysql_nlb" {
  value = "${module.proxysql.nlb}"
}
