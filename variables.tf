variable "cloudflare_api_token" {
  description = ""
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = ""
}

variable "dns_name" {
  description = ""
  default     = "elbschloss.xyz"
}


variable "hcloud_token" {
  description = ""
  sensitive   = true
}
