
locals {
  ip_list = [for vm in var.instance_names : aws_instance.instance[vm].public_ip]
  master_ip = aws_instance.instance[element(var.instance_names,0)].public_ip
  worker1_ip = aws_instance.instance[element(var.instance_names,1)].public_ip
  worker2_ip = aws_instance.instance[element(var.instance_names,2)].public_ip
}

output "ips" {
  value = join(";", local.ip_list)
}
