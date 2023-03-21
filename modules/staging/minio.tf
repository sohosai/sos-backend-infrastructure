module "minio" {
  source         = "../minio"
  tags           = concat(var.tags, ["sos23_minio"])
  zone           = var.zone
  switch_id      = sakuracloud_switch.internal.id
  switch_network = local.internal_network
  switch_netmask = local.internal_netmask
  port           = local.minio_port
  ip_address     = local.minio_ip_address
}
