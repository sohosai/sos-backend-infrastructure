variable "user_name" {
  type = string
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
