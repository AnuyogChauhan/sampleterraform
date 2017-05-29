variable "image" {
  default = "ubuntu-14"
}

variable "flavor" {
  default = "m1.small"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user_name" {
  default = "ubuntu"
}

variable "external_gateway" {}

variable "pool" {
  default = "external"
}

variable "ansible_script" {
  default = "nginx.yml"
}

variable "http_proxy" {}

variable "https_proxy" {}

variable "no_proxy" {}
