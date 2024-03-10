
locals {
  ip_list = [for vm in var.instance_names : aws_instance.instance[vm].public_ip]
}

output "ips" {
  value = join(";", local.ip_list)
}
