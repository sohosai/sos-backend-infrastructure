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

variable "user_name" {
  type    = string
  default = "sos21-admin"
}

variable "user_ssh_public_keys" {
  type = list(string)
}

variable "user_hashed_password" {
  type = string
}

variable "root_ssh_public_keys" {
  type = list(string)
}

variable "zone" {
  type    = string
  default = "is1a"
}

variable "internet_band_width" {
  type    = number
  default = 500
}
