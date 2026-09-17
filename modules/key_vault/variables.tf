variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "network_default_action" {
  type    = string
  default = "Deny"
}

variable "allowed_subnet_ids" {
  type    = list(string)
  default = []
}

variable "allowed_ip_addresses" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
