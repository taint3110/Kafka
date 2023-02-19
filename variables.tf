variable "do_token" {
  description = "Digital Ocean access token"
  type = string
}

variable "ssh_public_key" {
  description = "Public key to connect to instance through SSH"
}

variable "ssh_private_key" {
  description = "Private key to connect to instance through SSH"
}