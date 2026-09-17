resource "azurerm_key_vault" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  tenant_id                 = var.tenant_id
  sku_name                  = var.sku_name
  enable_rbac_authorization = true
  tags                      = var.tags
}
