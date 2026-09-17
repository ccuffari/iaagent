locals {
  location            = "westeurope"
  resource_group_name = "rg-ia-dev-we-01"
  storage_account_name = "<sa>"
  key_vault_name       = "link-kv-vnet"
  data_factory_name    = "<adf1>"
  sql_server_name      = "sql-ia-dev-we-01"
  sql_database_name    = "sqldb-ia-dev-we-01"
  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
