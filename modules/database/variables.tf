variable "tags" {
  type    = list(string)
  default = []
}

variable "zone" {
  type = string
}

variable "core" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 1
}

variable "data_disk_size" {
  type    = number
  default = 20
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

variable "port" {
  type = number
}
