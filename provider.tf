provider "sakuracloud" {
  zone   = var.zone
  token  = var.sakuracloud_access_token
  secret = var.sakuracloud_access_token_secret
}
