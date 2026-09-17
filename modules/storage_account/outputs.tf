# Output del modulo storage_account

output "id" {
  description = "ID dello storage account"
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Nome dello storage account"
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Endpoint primario del servizio Blob"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}
