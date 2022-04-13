module "beta" {
  source = "./modules/server"

  tags   = concat(var.tags, ["sos22_beta"])
  zone   = var.zone
  core   = 2
  memory = 2

  switch_id      = sakuracloud_switch.internal.id
  switch_netmask = local.internal_netmask
  switch_network = local.internal_network
  ip_address     = local.beta_ip_address

  router_id         = var.router_id
  global_ip_address = var.beta_ip_address

  root_ssh_public_keys = var.root_ssh_public_keys
  user_ssh_public_keys = var.user_ssh_public_keys
  user_hashed_password = var.user_hashed_password
  user_name            = var.user_name

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
