terraform {
  required_version = "1.4.2"

  required_providers {
    external = {
      version = "2.0.0"
      source  = "hashicorp/external"
    }
    sakuracloud = {
      version = "2.22.1"
      source  = "sacloud/sakuracloud"
    }
  }
}

