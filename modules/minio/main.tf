resource "sakuracloud_disk" "data_disk" {
  name = "sos23_minio_data_disk"
  tags = concat(var.tags, ["sos23_minio_data_disk"])
  zone = var.zone
  size = var.data_disk_size
}

resource "sakuracloud_disk" "disk" {
  name              = "sos23_minio_disk"
  tags              = concat(var.tags, ["sos23_minio_disk"])
  zone              = var.zone
  source_archive_id = module.nixos_minio.archive_id
}

resource "random_password" "access_key" {
  length  = 20
  special = false
}

resource "random_password" "secret_key" {
  length  = 120
  special = false
}

resource "sakuracloud_server" "minio" {
  name   = "sos23_minio"
  tags   = concat(var.tags, ["sos23_minio_server"])
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
