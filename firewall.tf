resource "hcloud_firewall" "dns-fw" {
  name = "DNS Server"

  labels = {
    "role" = "dns"
  }

  apply_to {
    label_selector = "role=dns"
  }

  rule {
    description = "allow ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow SSH from any"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow hetzner api and metadata servers tcp"
    direction   = "in"
    protocol    = "tcp"
    port        = "any"
    source_ips = [
      "169.254.169.254/32",
      "213.239.246.1/32",
    ]
  }

  rule {
    description = "allow hetzner api and metadata servers udp"
    direction   = "in"
    protocol    = "udp"
    port        = "any"
    source_ips = [
      "169.254.169.254/32",
      "213.239.246.1/32",
    ]
  }

  rule {
    description = "allow TCP DNS from ANY"
    direction   = "in"
    protocol    = "tcp"
    port        = "53"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow UDP DNS from ANY"
    direction   = "in"
    protocol    = "udp"
    port        = "53"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow TCP HTTPS from ANY"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow TCP HTTP from ANY"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow DNS over TLS from ANY"
    direction   = "in"
    protocol    = "tcp"
    port        = "853"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow DNS over QUIC from ANY"
    direction   = "in"
    protocol    = "tcp"
    port        = "784"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow Admin-UI from ANY"
    direction   = "in"
    protocol    = "tcp"
    port        = "3000"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow NodeExporter Traffic"
    direction   = "in"
    protocol    = "tcp"
    port        = "9100"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    description = "allow AdguardHomeExporter Traffic"
    direction   = "in"
    protocol    = "tcp"
    port        = "9617"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
}
