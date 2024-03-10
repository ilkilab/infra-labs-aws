variable "user_number" {
    type = number
    description = "Combien de stagiaires sont présents (compter également l'infrastructure pour le formateur)"
    validation {
      condition = var.user_number < 20
      error_message = "too many users"
    }
}

variable "formation_name" {
  description = "sujet de la formation"
  type = string
}

variable "instance_names" {
  type = list
  description = "liste des instances devant être déployées pour chaque stagaire"
  default = ["formation"]
}

variable "public_key_file" {
  description = "Clé publique de la paire fournie aux stagiaires"
}

variable "image" {
  type = string
  description = "Nom de l'image a utiliser"
  default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230517"
}

variable "image_owner" {
  type = string
  description = "Propriétaire de l'image"
  default = "amazon"
}

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

