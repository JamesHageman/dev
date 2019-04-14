variable "ssh_public_key" {
  default="${file(~/.ssh/uw.pub)}"
}

# when switching wifi, you can find your public ip with this command:
#   curl ifconfig.me
variable "local_public_ip_address" {
  default="24.56.243.216"
}
