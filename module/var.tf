variable "instance_names" {
  default = ["formation"]
}

variable "public_key" {
  type        = string
  description = "Cle publique a injecter dans les instances"
}

variable "user_number" {}

variable "ami" {
  default = "kubeadm1.28.7"
}

variable "ami_owner" {
  default = "self"
}