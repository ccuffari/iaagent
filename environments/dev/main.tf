module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = local.location
  tags     = local.tags
}

module "storage_account" {
  source                   = "../../modules/storage_account"
  name                     = var.storage_account_name
  resource_group_name      = module.resource_group.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = var.key_vault_name
  resource_group_name = module.resource_group.name
  location            = local.location
  tenant_id           = var.tenant_id
  sku_name            = "standard"
  tags                = local.tags
}

module "data_factory" {
  source              = "../../modules/data_factory"
  name                = var.data_factory_name
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
}
