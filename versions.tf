terraform {
  required_version = ">= 1.0.9"
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  backend "remote" {
    organization = "cedi"
    workspaces {
      name = "elbschloss"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

provider "hcloud" {
  token = var.hcloud_token
}