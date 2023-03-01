variable "do_token" {
  description = "Digital Ocean access token"
  type = string
}

variable "ssh_public_key" {
  description = "Public key to connect to instance through SSH"
}

variable "github_token" {
  description = "Github access token"
}