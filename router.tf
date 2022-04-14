locals {
  internet_netmask   = 28
  nightly_ip_address = sakuracloud_internet.router.ip_addresses[0]
  beta_ip_address    = sakuracloud_internet.router.ip_addresses[1]
  main_ip_address    = sakuracloud_internet.router.ip_addresses[2]
}

resource "sakuracloud_internet" "router" {
  name       = "sos22_router"
  zone       = var.zone
  netmask    = local.internet_netmask
  band_width = var.internet_band_width
}
