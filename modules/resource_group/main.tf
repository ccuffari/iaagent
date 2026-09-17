# Modulo: Resource Group
# Crea il resource group che ospita tutte le risorse dell'ambiente.

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
