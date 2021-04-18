module "beta" {
  source = "./modules/server"

  tags   = concat(var.tags, ["sos21_beta"])
  zone   = var.zone
  core   = 2
  memory = 2

  switch_id      = sakuracloud_switch.internal.id
  switch_netmask = local.internal_netmask
  switch_network = local.internal_network
  ip_address     = local.beta_ip_address

  router_id         = var.router_id
  global_ip_address = var.beta_ip_address

  ssh_public_key = var.ssh_public_key
  secret_contents = [
    {
      target  = "/var/keys/database-username"
      content = module.database.username
      mode    = "600"
    },
    {
      target  = "/var/keys/database-password"
      content = module.database.password
      mode    = "600"
    },
    {
      target  = "/var/keys/minio-access-key"
      content = module.minio.access_key
      mode    = "600"
    },
    {
      target  = "/var/keys/minio-secret-key"
      content = module.minio.secret_key
      mode    = "600"
    }
  ]
}
