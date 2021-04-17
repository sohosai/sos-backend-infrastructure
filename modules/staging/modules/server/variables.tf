variable "ssh_public_key" {
  type = string
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "zone" {
  type = string
}

variable "core" {
  type = number
}

variable "memory" {
  type = number
}

variable "switch_id" {
  type = string
}

variable "switch_netmask" {
  type = string
}

variable "switch_network" {
  type = string
}

variable "ip_address" {
  type = string
}

variable "router_id" {
  type = string
}

variable "global_ip_address" {
  type = string
}

variable "contents" {
  type    = list(map(string))
  default = []
}

variable "secret_contents" {
  type    = list(map(string))
  default = []
}
