resource "cloudflare_record" "beta" {
  zone_id = var.cloudflare_zone_id
  name    = "api.beta.online"
  value   = local.beta_ip_address
  type    = "A"
  # value of 1 is 'automatic'
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "nightly" {
  zone_id = var.cloudflare_zone_id
  name    = "api.nightly.online"
  value   = local.nightly_ip_address
  type    = "A"
  # value of 1 is 'automatic'
  ttl     = 1
  proxied = true
}
