# Output del modulo key_vault

output "id" {
  description = "ID del Key Vault"
  value       = azurerm_key_vault.this.id
}

output "name" {
  description = "Nome del Key Vault"
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "URI del Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}
