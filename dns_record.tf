# 'proxied' records for free TLS (HTTPS) and direct records for deployments via SSH

resource "cloudflare_record" "beta" {
  zone_id = var.cloudflare_zone_id
  name    = "online-api-beta"
  value   = local.beta_ip_address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "beta_direct" {
  zone_id = var.cloudflare_zone_id
  name    = "direct.online-api-beta"
  value   = local.beta_ip_address
  type    = "A"
  # value of 1 is 'automatic'
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "nightly" {
  zone_id = var.cloudflare_zone_id
  name    = "online-api-nightly"
  value   = local.nightly_ip_address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "nightly_direct" {
  zone_id = var.cloudflare_zone_id
  name    = "direct.online-api-nightly"
  value   = local.nightly_ip_address
  type    = "A"
  # value of 1 is 'automatic'
  ttl     = 1
  proxied = false
}
