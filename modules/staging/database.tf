module "database" {
  source         = "../database"
  tags           = concat(var.tags, ["sos23_database"])
  zone           = var.zone
  switch_id      = sakuracloud_switch.internal.id
  switch_network = local.internal_network
  switch_netmask = local.internal_netmask
  port           = local.database_port
  ip_address     = local.database_ip_address
}
