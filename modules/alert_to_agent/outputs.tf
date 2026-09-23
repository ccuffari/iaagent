# Output del modulo alert_to_agent

output "alert_id" {
  value       = azurerm_monitor_metric_alert.this.id
  description = "ID del metric alert"
}

output "action_group_id" {
  value       = azurerm_monitor_action_group.this.id
  description = "ID dell'action group"
}

output "action_group_name" {
  value       = azurerm_monitor_action_group.this.name
  description = "Nome dell'action group"
}
