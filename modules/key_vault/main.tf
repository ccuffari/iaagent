data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  enable_rbac_authorization  = true
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  tags                       = var.tags

  network_acls {
    default_action             = var.network_default_action
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.allowed_subnet_ids
    ip_rules                   = var.allowed_ip_addresses
  }
}
