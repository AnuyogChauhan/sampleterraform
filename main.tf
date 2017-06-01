provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "mypass"
  auth_url    = "http://172.19.74.170:5000/v2.0"
  domain_name = "default"
}

resource "openstack_compute_keypair_v2" "terraform_keypair" {
  name       = "terraform_keypair"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}



resource "openstack_compute_floatingip_v2" "terraform_floatingIP" {
  pool       = "external"
}

resource "openstack_compute_instance_v2" "terraform_instance" {
  name            = "terraform_instance"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.terraform_keypair.name}"
  security_groups = ["default"]
  floating_ip     = "${openstack_compute_floatingip_v2.terraform_floatingIP.address}"

  network {
    uuid = "cb3abed9-5fed-4797-a759-f3bbef7846be"
  }
}

