output "id" {
  value = azurerm_databricks_workspace.this.id
}

output "name" {
  value = azurerm_databricks_workspace.this.name
}

output "workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}

output "principal_id" {
  value = azurerm_databricks_workspace.this.identity[0].principal_id
}
