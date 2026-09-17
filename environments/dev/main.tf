module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "rgiaagentdevwe01"
  location = local.location
  tags     = local.tags
}

module "storage_account" {
  source               = "../../modules/storage_account"
  name                 = "staiagentdevwe01"
  resource_group_name  = module.resource_group.name
  location             = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                 = local.tags
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = "kviaagentdevwe01"
  resource_group_name = module.resource_group.name
  location            = local.location
  sku_name            = "standard"
  tags                = local.tags
}
