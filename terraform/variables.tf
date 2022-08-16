variable "ssh_public_key_filepath" {
  type    = string
  default = "~/.ssh/code_server_rsa.pub"
}

variable "domain_zone_id" {
  type    = string
  default = ""
}

variable "domain_name" {
  type    = string
  default = ""
}
