data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

import {
  to = module.storage_account.azurerm_storage_account.this
  id = "/subscriptions/f4a32007-b8c2-4aee-9dc0-1421a27e36ad/resourceGroups/rg-ia-dev-we-01/providers/Microsoft.Storage/storageAccounts/<sa>"
}

module "storage_account" {
  source                   = "../../modules/storage_account"
  name                     = local.storage_account_name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

import {
  to = module.key_vault.azurerm_key_vault.this
  id = "/subscriptions/f4a32007-b8c2-4aee-9dc0-1421a27e36ad/resourceGroups/rg-ia-dev-we-01/providers/Microsoft.KeyVault/vaults/link-kv-vnet"
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = local.key_vault_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = local.tags
}

import {
  to = module.data_factory.azurerm_data_factory.this
  id = "/subscriptions/f4a32007-b8c2-4aee-9dc0-1421a27e36ad/resourceGroups/rg-ia-dev-we-01/providers/Microsoft.DataFactory/factories/<adf1>"
}

module "data_factory" {
  source              = "../../modules/data_factory"
  name                = local.data_factory_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
  tags                = local.tags
}

module "sql_server" {
  source              = "../../modules/sql_server"
  name                = local.sql_server_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
  key_vault_id        = module.key_vault.id
  tags                = local.tags
}

module "sql_database" {
  source    = "../../modules/sql_database"
  name      = local.sql_database_name
  server_id = module.sql_server.id
  sku_name  = "GP_S_Gen5_1"
}
