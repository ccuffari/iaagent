data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

import {
  to = module.storage_account.azurerm_storage_account.this
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
}

module "storage_account" {
  source                   = "../../modules/storage_account"
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

import {
  to = module.key_vault.azurerm_key_vault.this
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.key_vault_name}"
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = local.tags
}

import {
  to = module.data_factory.azurerm_data_factory.this
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DataFactory/factories/${var.data_factory_name}"
}

module "data_factory" {
  source              = "../../modules/data_factory"
  name                = var.data_factory_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  tags                = local.tags
}

module "sql_server" {
  source              = "../../modules/sql_server"
  name                = var.sql_server_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  key_vault_id        = module.key_vault.id
  tags                = local.tags
}

module "sql_database" {
  source    = "../../modules/sql_database"
  name      = var.sql_database_name
  server_id = module.sql_server.id
  sku_name  = "GP_S_Gen5_1"
}
