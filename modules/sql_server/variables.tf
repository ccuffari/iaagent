variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_login" {
  type      = string
  sensitive = true
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
