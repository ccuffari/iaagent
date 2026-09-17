# Output del modulo resource_group

output "id" {
  description = "ID del resource group"
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "Nome del resource group"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Regione del resource group"
  value       = azurerm_resource_group.this.location
}
