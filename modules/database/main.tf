resource "sakuracloud_disk" "data_disk" {
  name = "sos21_database_data_disk"
  tags = concat(var.tags, ["sos21_database_data_disk"])
  zone = var.zone
  size = var.data_disk_size
}

resource "sakuracloud_disk" "disk" {
  name              = "sos21_database_disk"
  tags              = concat(var.tags, ["sos21_database_disk"])
  zone              = var.zone
  source_archive_id = module.nixos_database.archive_id
}

resource "random_password" "username" {
  length  = 20
  special = false
}

resource "random_password" "password" {
  length  = 80
  special = false
}

resource "sakuracloud_server" "database" {
  name   = "sos21_database"
  tags   = concat(var.tags, ["sos21_database_server"])
  disks  = [sakuracloud_disk.disk.id, sakuracloud_disk.data_disk.id]
  zone   = var.zone
  core   = var.core
  memory = var.memory

  network_interface {
    upstream         = var.switch_id
    user_ip_address  = var.ip_address
    packet_filter_id = sakuracloud_packet_filter.switch.id
  }
}
