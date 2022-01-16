resource "hcloud_server" "hole" {
  name        = "hole"
  count = 3
  server_type = "cx11"
  image       = "ubuntu-20.04"
  location    = "fsn1"
  ssh_keys = [
    hcloud_ssh_key.cedi_ivy.name,
    hcloud_ssh_key.cedi_ava.name,
    hcloud_ssh_key.cedi_liv.name,
    hcloud_ssh_key.cedi_devpi.name,
    hcloud_ssh_key.root_adguard.name
  ]

  labels = {
    "role" = "dns"
  }
}
