variable "ssh_public_keys" {
  type = list(string)
}

variable "tags" {
  type = list(string)
}

variable "zone" {
  type = string
}

variable "router_id" {
  type = string
}

variable "nightly_ip_address" {
  type = string
}

variable "beta_ip_address" {
  type = string
}
