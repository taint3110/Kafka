terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.26.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "web" {
  image              = "ubuntu-18-04-x64"
  name               = "tai-kafka"
  region             = "sgp1"
  size               = "s-1vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

resource "digitalocean_ssh_key" "default" {
  name = "tai-kafka"
  public_key = file("~/.ssh/kafka_rsa.pub")
}