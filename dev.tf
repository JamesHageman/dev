provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

# Create a new domain
resource "digitalocean_domain" "cloud" {
  name = "cloud.jameshageman.com"
}

# Create a new SSH key
resource "digitalocean_ssh_key" "dev" {
  name       = "dev"
  public_key = "${vars.ssh_public_key}"
}

# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "dev1" {
  image    = "ubuntu-18-04-x64"
  name     = "dev1.sfo2"
  region   = "sfo2"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ssh_key.dev.fingerprint}"]
}

# Create a floating (static) ip for the droplet
resource "digitalocean_floating_ip" "dev1" {
  droplet_id = "${digitalocean_droplet.dev1.id}"
  region     = "${digitalocean_droplet.dev1.region}"
}

# Add an A record to point at the droplet
resource "digitalocean_record" "dev1" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "${digitalocean_droplet.dev1.name}"
  value  = "${digitalocean_floating_ip.dev1.ip_address}"
}

resource "digitalocean_firewall" "laptop_ssh" {
  name = "laptop-ssh-access"

  droplet_ids = ["${digitalocean_droplet.dev1.id}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["${vars.local_public_ip_address}"]
    },
  ]
}

resource "digitalocean_firewall" "public_egress" {
  name = "public-egress"

  droplet_ids = ["${digitalocean_droplet.dev1.id}"]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}

