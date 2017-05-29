provider "openstack" {
  user_name   = "apiaccessuser"
  tenant_name = "eu-de"
  password    = "edge786!"
  auth_url    = "https://iam.eu-de.otc.t-systems.com:443/v3"
  domain_name = "OTC00000000001000009996"
}

# Create a web server
resource "openstack_compute_instance_v2" "test-server" {
  name            = "testserver"
  image_id        = "23eff5f2-4a06-41cb-93df-76b7064ed37e"
  flavor_id       = "computev2-1"
  key_pair        = "DtEdge_OTC_EU_DE"
  security_groups = ["default"]

  network {
    uuid = "657a51ef-204c-417d-9022-67df7e43fdf0"
    access_network = true
  }
}
