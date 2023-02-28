
resource "digitalocean_ssh_key" "default" {
  name       = "DO Default SSH Key"
  public_key = var.ssh_public_key
}

resource "digitalocean_droplet" "example" {
  image  = "ubuntu-20-04-x64"
  name   = "kafka"
  region = "sgp1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  user_data = <<-EOF
        #!/bin/bash
    # # CREATE SWAP
    # sudo fallocate -l 4G /swapfile
    # sudo chmod 600 /swapfile
    # sudo mkswap /swapfile
    # sudo swapon /swapfile
    # sudo cat /etc/fstab >> /swapfile swap swap defaults 0 0

    # INSTALL DOCKER
    su -c "curl -sSL https://get.docker.com/ | sh"
    sudo sh get-docker.sh

    # # ADD DOCKER USER AS ROOT USER
    # sudo groupadd docker
    # sudo usermod -aG docker $USER
    # newgrp docker
    # sudo chmod 666 /var/run/docker.sock

    # # INSTALL DOCKER COMPOSE
    # sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # sudo chmod +x /usr/local/bin/docker-compose
    # sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    # # SET MAX SESSION FOR SSH VPS
    # echo "MaxSessions 50" >> /etc/ssh/sshd_config

    # # INSTALL GIT
    # sudo apt-get update
    # sudo apt-get install git
    # git clone https://taint3110:"${var.github_token}"@github.com/taint3110/Kafka
    # cd Kafka
    # docker-compose up -d

  EOF

  connection {
    type        = "ssh"
    user        = "root"
    private_key = var.ssh_private_key
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "echo '${var.ssh_public_key}' >> ~/.ssh/authorized_keys",
      "chmod 700 ~/.ssh",
      "chmod 600 ~/.ssh/authorized_keys",
      "service ssh restart",
    ]
  }
}