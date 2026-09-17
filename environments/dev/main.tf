data "azurerm_client_config" "current" {}

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "iacrgtestwe01"
  location = local.location
  tags     = local.tags
}

module "storage" {
  source                   = "../../modules/storage"
  name                     = "staiagentwe01"
  resource_group_name             = module.resource_group.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

module "keyvault" {
  source       = "../../modules/keyvault"
  name         = "link-kv-vnet"
  resource_group_name = module.resource_group.name
  location     = local.location
  tenant_id    = data.azurerm_client_config.current.tenant_id
  sku_name     = "standard"
  tags         = local.tags
}

module "datafactory" {
  source       = "../../modules/datafactory"
  name         = "Terraform"
  resource_group_name = module.resource_group.name
  location     = local.location
  tags         = local.tags
}
