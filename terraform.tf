
resource "digitalocean_ssh_key" "default" {
  name       = "DO Default SSH Key"
  public_key = var.ssh_public_key
}

resource "digitalocean_droplet" "kafka" {
  image  = "ubuntu-20-04-x64"
  name   = "kafka"
  region = "sgp1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  user_data = file("kafka-server.sh")
}