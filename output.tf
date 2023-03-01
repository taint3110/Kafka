output "droplet_output" {
  value = digitalocean_droplet.kafka.ipv4_address
}
