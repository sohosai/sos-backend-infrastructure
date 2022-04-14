resource "sakuracloud_disk" "server_disk" {
  name              = "sos22_staging_server_disk"
  tags              = concat(var.tags, ["sos22_server_disk"])
  zone              = var.zone
  source_archive_id = module.nixos_archive.archive_id
}

resource "sakuracloud_server" "server" {
  name   = "sos22_staging_server"
  tags   = concat(var.tags, ["sos22_server"])
  disks  = [sakuracloud_disk.server_disk.id]
  zone   = var.zone
  core   = var.core
  memory = var.memory

  network_interface {
    upstream         = data.sakuracloud_internet.router.switch_id
    user_ip_address  = var.global_ip_address
    packet_filter_id = sakuracloud_packet_filter.external.id
  }

  network_interface {
    upstream        = var.switch_id
    user_ip_address = var.ip_address
  }
}
