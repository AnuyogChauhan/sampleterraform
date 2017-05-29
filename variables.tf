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

variable "external_gateway" {
  default = "09dcce3e-906d-4afa-8b90-ac04593a0f5d"
  }

variable "pool" {
  default = "external"
}

variable "ansible_script" {
  default = "nginx.yml"
}

variable "http_proxy" {
  default = "http://165.225.104.34:80"
  }

variable "https_proxy" {
  default = "https://165.225.104.34:80"
  }

variable "no_proxy" {
  default = "localhost,127.0.0.1,15.*,16.*,172*"
  }
