module "minio" {
  source         = "../minio"
  tags           = concat(var.tags, ["sos22_minio"])
  zone           = var.zone
  switch_id      = sakuracloud_switch.internal.id
  switch_network = local.internal_network
  switch_netmask = local.internal_netmask
  port           = local.minio_port
  ip_address     = local.minio_ip_address

  core           = 2
  memory         = 4
  data_disk_size = 1024
}

resource "sakuracloud_auto_backup" "minio_auto_backup" {
  name = "sos22_production_minio_backup"
  tags = concat(var.tags, ["sos22_auto_backup"])
  zone = var.zone

  disk_id        = module.minio.data_disk_id
  weekdays       = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
  max_backup_num = 5
}
