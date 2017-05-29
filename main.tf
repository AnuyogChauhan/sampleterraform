provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "mypass"
  auth_url    = "http://172.19.74.170:5000/v2.0"
  domain_name = "default"
}

resource "openstack_compute_keypair_v2" "terraform" {
  name       = "terraform"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

resource "openstack_networking_network_v2" "terraform" {
  name           = "terraform"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "terraform" {
  name            = "terraform"
  network_id      = "${openstack_networking_network_v2.terraform.id}"
  cidr            = "30.0.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "terraform" {
  name             = "terraform"
  admin_state_up   = "true"
#  external_gateway = "${var.external_gateway}"
}

resource "openstack_networking_router_interface_v2" "terraform" {
  router_id = "${openstack_networking_router_v2.terraform.id}"
  subnet_id = "${openstack_networking_subnet_v2.terraform.id}"
}

resource "openstack_compute_secgroup_v2" "terraform" {
  name        = "terraform"
  description = "Security group for the Terraform example instances"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_floatingip_v2" "terraform" {
  pool       = "${var.pool}"
  depends_on = ["openstack_networking_router_interface_v2.terraform"]
}

resource "openstack_compute_instance_v2" "terraform" {
  name            = "terraform"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = ["${openstack_compute_secgroup_v2.terraform.name}"]
  floating_ip     = "${openstack_compute_floatingip_v2.terraform.address}"

  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
  }
  provisioner "file" {
    source      = "${var.ansible_script}"
    destination = "/tmp/${var.ansible_script}"
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"

  }
}
  provisioner "file" {
    source      = "apt.conf"
    destination = "/tmp/apt.conf"
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"

  }
}
  provisioner "file" {
    source      = "set_proxy.sh"
    destination = "/tmp/set_proxy.sh"
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"

  }
}

  provisioner "file" {
    source      = "hosts"
    destination = "/tmp/hosts"
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"

  }
}
  provisioner "remote-exec" {
    connection {
      user     = "${var.ssh_user_name}"
      private_key = "${file(var.ssh_key_file)}"
    }

    inline = [
#      "export http_proxy=http://165.225.104.34:80/",
      "export http_proxy=${var.http_proxy}",
#      "export https_proxy=https://165.225.104.34:80",
      "export https_proxy=${var.https_proxy}",
#      "export no_proxy=localhost,127.0.0.1,15.*,16.*,172*",
      "export no_proxy=${var.no_proxy}",
      "wget google.com",
      "sudo chmod 777 /etc/apt",
#      "touch /etc/apt/apt.conf",
      "touch /tmp/apt.conf",
      "sudo chmod 777 /tmp/set_proxy.sh",
      "/tmp/set_proxy.sh",
      "sudo chmod 777 /etc/apt",
      "sudo mv /tmp/apt.conf /etc/apt/",
      "cat /etc/apt/apt.conf",
       "sudo chmod 777 /var",
       "sudo chmod 777 /var/lib/dpkg/lock",
       "sudo chmod 777 /var/cache/apt/",
       "sudo chmod 777 /var/lib/dpkg",
       "sudo chmod 777 /var/cache/apt/archives/lock",
      "sudo chmod 777 /var/cache/apt/archives/partial/",
#      "sudo apt-get update",
#      "sudo apt-cache policy docker-engine",
#      "sudo apt-get install -y docker",
#      "sudo service docker status",
#      "docker run hello-world",
       "sudo apt-get install -y ansible",
       "ansible-playbook -i 'localhost,' -c local /tmp/nginx.yml",
    ]
}
}

