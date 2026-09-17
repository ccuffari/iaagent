# Ambiente: dev
# Composizione dei moduli per l'ambiente di sviluppo.

# Resource Group: rg-ia-dev-we-01
module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "rg-ia-dev-we-01"
  location = local.location
  tags     = local.tags
}

# Storage Account: saiadevwe01
module "storage_account" {
  source                   = "../../modules/storage_account"
  name                     = "saiadevwe01"
  resource_group_name      = module.resource_group.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

# Key Vault: kviadevwe01
module "key_vault" {
  source              = "../../modules/key_vault"
  name                = "kviadevwe01"
  resource_group_name = module.resource_group.name
  location            = local.location
  sku_name            = "standard"
  tags                = local.tags
}
