terraform {
  required_version = "0.14.8"

  required_providers {
    sakuracloud = {
      version = "2.8.3"
      source  = "sacloud/sakuracloud"
    }
    cloudflare = {
      version = "2.7.0"
      source  = "nixpkgs/cloudflare"
    }
  }

  backend "remote" {
  	organization = "sohosai"
    workspaces{
      name = "sos21-backend-infrastructure"
    }
  }
}

