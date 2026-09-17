data "azurerm_client_config" "current" {}

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

module "storage_account" {
  source              = "../../modules/storage_account"
  name                = local.storage_account_name
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = local.key_vault_name
  resource_group_name = module.resource_group.name
  location            = local.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "data_factory" {
  source              = "../../modules/data_factory"
  name                = local.data_factory_name
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
}
