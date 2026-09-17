variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "admin_login_secret_name" {
  type    = string
  default = "sql-admin-login"
}

variable "admin_password_secret_name" {
  type    = string
  default = "sql-admin-password"
}

variable "tags" {
  type    = map(string)
  default = {}
}
