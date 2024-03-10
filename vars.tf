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
    default = "ssh-formation.pub"
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