data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

data "azurerm_key_vault" "this" {
  name                = local.key_vault_name
  resource_group_name = data.azurerm_resource_group.this.name
}

module "sql_server" {
  source              = "../../modules/sql_server"
  name                = local.sql_server_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
  key_vault_id        = data.azurerm_key_vault.this.id
  tags                = local.tags
}

module "sql_database" {
  source    = "../../modules/sql_database"
  name      = local.sql_database_name
  server_id = module.sql_server.id
  sku_name  = "GP_S_Gen5_1"
}
