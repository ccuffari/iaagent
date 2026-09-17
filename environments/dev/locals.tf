locals {
  location            = "westeurope"
  resource_group_name = "rg-ia-dev-we-01"
  key_vault_name      = "link-kv-vnet"
  sql_server_name     = "sql-ia-dev-we-01"
  sql_database_name   = "sqldb-ia-dev-we-01"
  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
