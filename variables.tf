variable "name" {}
variable "namespace" {}

variable "zt_networks" {
  type = list(string)
}

variable "zt_identity_public" {}
variable "zt_identity_secret" {}

variable "services" {
  type = map(object({
    local_port  = string
    remote_ip   = string
    remote_port = number
  }))
}

variable "zt_image" {
  type    = string
  default = "zerotier/zerotier"
}