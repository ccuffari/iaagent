resource "azurerm_data_factory" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tags                       = var.tags
}
