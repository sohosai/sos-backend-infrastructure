variable "name" {
  type    = string
  default = "nixos"
}

variable "nixos_config" {
  type        = string
  description = "NixOS configuration.nix file content"
}

variable "contents" {
  type        = list(map(string))
  description = "List of files to be placed in the target file system"
  default     = []
}

variable "secret_contents" {
  type        = list(map(string))
  description = "List of files to be placed in the target file system"
  default     = []
}

variable "zone" {
  type = string
}

variable "tags" {
  type    = list(string)
  default = []
}
