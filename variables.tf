variable "sakuracloud_access_token" {
  type = string
}

variable "sakuracloud_access_token_secret" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "zone" {
  type    = string
  default = "is1a"
}

variable "internet_band_width" {
  type    = number
  default = 500
}
