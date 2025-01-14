terraform {
  required_version = "1.4.2"

  required_providers {
    sakuracloud = {
      version = "2.22.1"
      source  = "sacloud/sakuracloud"
    }
    cloudflare = {
      version = "4.2.0"
      source  = "cloudflare/cloudflare"
    }
  }

  backend "remote" {
    organization = "sohosai"
    workspaces {
      name = "sos23-backend-infrastructure"
    }
  }
}
