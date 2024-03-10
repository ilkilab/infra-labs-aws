resource "aws_key_pair" "key_pair" {
  key_name   = "key_pair_${var.formation_name}"
  public_key = file(var.public_key_file)
  tags = {
    DoNotDelete = "true"
  }
  lifecycle {
    create_before_destroy = true
  }
}

module "infra_formation" {
    count = var.user_number
    source = "./module"
    user_number = tostring(count.index)
    instance_names = var.instance_names
    ami = var.image
    ami_owner = var.image_owner
    public_key = aws_key_pair.key_pair.key_name
}

resource "local_file" "ip" {
  filename = "formation_${formatdate("DD_MM_YY",timestamp())}.csv"
  content = local.content
  depends_on = [
    module.infra_k8s
  ]
}

locals {
  ip_list = [for k, v in module.infra_formation : module.infra_formation[k].ips]
  content = "User;${join(";", var.instance_names)}\n${join("\n", local.ip_list)}"
}

output "test" {
  value = local.content
}

