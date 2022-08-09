variable "ami" {
  type = string
  # ubuntu 22.04 AMI
  default = "ami-04c65fa50a4122444"
}

variable "instance_type" {
  type = string
  # 使用 Amazom 自家 ARM CPU 的 Server，費用會比較便宜
  default = "t4g.small"
}

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
