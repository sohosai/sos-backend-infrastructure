terraform {
  required_version = "0.14.8"

  required_providers {
    random = {
      version = "3.0.0"
      source  = "hashicorp/random"
    }
    sakuracloud = {
      version = "2.7.1"
      source  = "sacloud/sakuracloud"
    }
  }
}

