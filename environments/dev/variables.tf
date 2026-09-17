variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "storage_account_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "data_factory_name" {
  type = string
}

variable "sql_server_name" {
  type    = string
  default = "sql-ia-dev-we-01"
}

variable "sql_database_name" {
  type    = string
  default = "sqldb-ia-dev-we-01"
}
