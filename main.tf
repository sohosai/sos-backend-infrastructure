module "staging" {
  source = "./modules/staging"
  tags   = ["sos21_staging"]
  zone   = "is1a"

  root_ssh_public_keys = var.root_ssh_public_keys
  user_ssh_public_keys = var.user_ssh_public_keys
  user_hashed_password = var.user_hashed_password

  router_id          = sakuracloud_internet.router.id
  nightly_ip_address = local.nightly_ip_address
  beta_ip_address    = local.beta_ip_address
}
