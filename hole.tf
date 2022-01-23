resource "hcloud_server" "hole" {
  name        = "hole"
  server_type = "cx11"
  image       = "ubuntu-20.04"
  location    = "fsn1"
  ssh_keys = [
    hcloud_ssh_key.cedi_ivy.name,
    hcloud_ssh_key.cedi_mae.name,
    hcloud_ssh_key.cedi_liv.name,
    hcloud_ssh_key.cedi_devpi.name
  ]

  labels = {
    "role" = "dns"
  }
}

resource "hcloud_rdns" "hole_v4" {
  server_id  = hcloud_server.hole.id
  ip_address = hcloud_server.hole.ipv4_address
  dns_ptr    = "${hcloud_server.hole.name}.${var.dns_name}"
}

resource "hcloud_rdns" "hole_v6" {
  server_id  = hcloud_server.hole.id
  ip_address = hcloud_server.hole.ipv6_address
  dns_ptr    = "${hcloud_server.hole.name}.${var.dns_name}"
}

resource "cloudflare_record" "hole_v4" {
  zone_id = var.cloudflare_zone_id
  name    = hcloud_server.hole.name
  value   = hcloud_server.hole.ipv4_address
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "hole_v6" {
  zone_id = var.cloudflare_zone_id
  name    = hcloud_server.hole.name
  value   = hcloud_server.hole.ipv6_address
  type    = "AAAA"
  ttl     = 1
}