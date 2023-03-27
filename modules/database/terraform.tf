terraform {
  required_version = "1.4.2"

  required_providers {
    random = {
      version = "3.4.3"
      source  = "hashicorp/random"
    }
    sakuracloud = {
      version = "2.22.1"
      source  = "sacloud/sakuracloud"
    }
  }
}

