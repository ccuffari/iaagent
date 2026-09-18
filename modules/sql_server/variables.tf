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

variable "enable_vnet_rule" {
  description = "Abilita la regola VNet sul SQL Server. Flag NOTO a plan time (evita count/for_each unknown)."
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
