locals {
  location = var.location
  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }

  resource_group_name = "rg-ia-dev-we-01"
  storage_account_name = "saiadevwe01"
  key_vault_name       = "kviadevwe01"

  data_factory_name = "adfiadevwe01"
  sql_server_name   = "sqliadevwe01"
  sql_database_name = "sqldbiadevwe01"
}
