# Modulo: alert_to_agent
# Crea un Metric Alert Azure Monitor + Action Group con webhook verso l'agente.
# Il webhook invoca l'agente (via Cloudflare Tunnel) che diagnostica e propone remediation.

resource "azurerm_monitor_action_group" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name          = email_receiver.value.name
      email_address = email_receiver.value.email
    }
  }

  dynamic "webhook_receiver" {
    for_each = var.agent_webhook_url != "" ? [1] : []
    content {
      name                    = "agent-webhook"
      service_uri             = var.agent_webhook_url
      use_common_alert_schema = true

      dynamic "aad_auth" {
        for_each = var.webhook_token != "" ? [1] : []
        content {
          object_id      = var.webhook_auth_object_id
          tenant_id      = var.webhook_auth_tenant_id
          identifier_uri = var.webhook_auth_identifier_uri
        }
      }
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  scopes              = [var.target_resource_id]
  description         = var.description
  severity            = var.severity
  enabled             = var.enabled
  frequency           = var.frequency
  window_size         = var.window_size

  criteria {
    metric_namespace = var.metric_namespace
    metric_name      = var.metric_name
    aggregation      = var.aggregation
    operator         = var.operator
    threshold        = var.threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }

  tags = var.tags
}
