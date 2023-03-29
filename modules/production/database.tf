module "database" {
  source         = "../database"
  tags           = concat(var.tags, ["sos23_database"])
  zone           = var.zone
  switch_id      = sakuracloud_switch.internal.id
  switch_network = local.internal_network
  switch_netmask = local.internal_netmask
  port           = local.database_port
  ip_address     = local.database_ip_address

  core           = 2
  memory         = 4
  data_disk_size = 500
}

resource "sakuracloud_auto_backup" "database_auto_backup" {
  name = "sos23_production_database_backup"
  tags = concat(var.tags, ["sos23_auto_backup"])
  zone = var.zone

  disk_id        = module.database.data_disk_id
  weekdays       = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
  max_backup_num = 5
}
