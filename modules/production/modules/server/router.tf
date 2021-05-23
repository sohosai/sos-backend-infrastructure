data "sakuracloud_internet" "router" {
  filter {
    id = var.router_id
  }
  zone = var.zone
}
