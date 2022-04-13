locals {
  internal_netmask = 24
  internal_network = "192.168.0.0"

  database_ip_address = "192.168.0.11"
  database_port       = 5432
  minio_ip_address    = "192.168.0.12"
  minio_port          = 9000
  beta_ip_address     = "192.168.0.13"
  nightly_ip_address  = "192.168.0.14"
}

resource "sakuracloud_switch" "internal" {
  name = "sos22_staging_switch"
  tags = concat(var.tags, ["sos22_switch"])
  zone = var.zone
}
