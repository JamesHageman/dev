variable "digitalocean_token" {}
variable "ssh_public_key" {}
variable "local_public_ip_address" {}
variable "region" {}

variable "droplet_name" {
  default = "dev1"
}

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
  public_key = "${var.ssh_public_key}"
}

# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "devbox" {
  image      = "ubuntu-18-04-x64"
  name       = "${var.droplet_name}.${var.region}"
  region     = "${var.region}"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys   = ["${digitalocean_ssh_key.dev.fingerprint}"]

  provisioner "remove-exec" {
    inline = [
      "git clone https://github.com/JamesHageman/dev",
      "~/dev/bootstrap.sh",
    ]
  }
}

# Create a floating (static) ip for the droplet
resource "digitalocean_floating_ip" "devbox_ip" {
  droplet_id = "${digitalocean_droplet.devbox.id}"
  region     = "${digitalocean_droplet.devbox.region}"
}

# Add an A record to point at the droplet
resource "digitalocean_record" "devbox_a_record" {
  domain = "${digitalocean_domain.cloud.name}"
  type   = "A"
  ttl    = 60
  name   = "${digitalocean_droplet.devbox.name}"
  value  = "${digitalocean_floating_ip.devbox_ip.ip_address}"
}

resource "digitalocean_firewall" "laptop_ssh" {
  name = "laptop-ssh-access"

  droplet_ids = ["${digitalocean_droplet.devbox.id}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["${var.local_public_ip_address}"]
    },
    {
      protocol         = "udp"
      port_range       = "60000-61000"
      source_addresses = ["${var.local_public_ip_address}"]
    },
  ]
}

resource "digitalocean_firewall" "public_egress" {
  name = "public-egress"

  droplet_ids = ["${digitalocean_droplet.devbox.id}"]

  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}

output "devbox_hostname" {
  value = "${digitalocean_record.devbox_a_record.fqdn}"
}
