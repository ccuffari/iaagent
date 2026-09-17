module "resource_group" {
  source   = "../../modules/resource_group"
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

module "storage_account" {
  source              = "../../modules/storage_account"
  name                = "saaidevwe01"
  resource_group_name = module.resource_group.name
  location            = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                = local.tags
}

module "data_factory" {
  source              = "../../modules/data_factory"
  name                = "adf-ai-dev-we-01"
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = "kv-ai-dev-we-01"
  resource_group_name = module.resource_group.name
  location            = local.location
  tenant_id           = local.tenant_id
  sku_name            = "standard"
  tags                = local.tags
}

module "log_analytics" {
  source              = "../../modules/log_analytics"
  name                = "log-ai-dev-we-01"
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
}
