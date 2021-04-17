module "staging" {
  source         = "./modules/staging"
  tags           = ["sos21_staging"]
  zone           = "is1a"
  ssh_public_key = var.ssh_public_key

  router_id          = sakuracloud_internet.router.id
  nightly_ip_address = local.nightly_ip_address
  beta_ip_address    = local.beta_ip_address
}
