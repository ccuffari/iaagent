# Variabili del modulo alert_to_agent

variable "name" {
  type        = string
  description = "Nome dell'alert e dell'action group"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group di destinazione"
}

variable "short_name" {
  type        = string
  description = "Short name dell'action group (max 12 caratteri)"
}

variable "target_resource_id" {
  type        = string
  description = "ID della risorsa da monitorare"
}

variable "metric_namespace" {
  type        = string
  description = "Namespace della metrica (es. Microsoft.Sql/servers/databases)"
}

variable "metric_name" {
  type        = string
  description = "Nome della metrica (es. dtu_consumption_percent)"
}

variable "aggregation" {
  type        = string
  description = "Aggregazione (Average, Total, Count, Max, Min)"
  default     = "Average"
}

variable "operator" {
  type        = string
  description = "Operatore (GreaterThan, LessThan, GreaterOrLessThan)"
  default     = "GreaterThan"
}

variable "threshold" {
  type        = number
  description = "Soglia dell'alert"
}

variable "severity" {
  type        = number
  description = "Severita' (0-4)"
  default     = 2
}

variable "frequency" {
  type        = string
  description = "Frequenza di valutazione (es. PT1M, PT5M)"
  default     = "PT5M"
}

variable "window_size" {
  type        = string
  description = "Finestra di aggregazione (es. PT5M, PT15M)"
  default     = "PT5M"
}

variable "description" {
  type        = string
  description = "Descrizione dell'alert"
  default     = "Alert gestito da Terraform (alert_to_agent)"
}

variable "enabled" {
  type        = bool
  description = "Abilita l'alert"
  default     = true
}

variable "agent_webhook_url" {
  type        = string
  description = "URL del webhook dell'agente (Cloudflare Tunnel)"
  default     = ""
}

variable "webhook_token" {
  type        = string
  description = "Token di autenticazione del webhook (da Key Vault)"
  default     = ""
  sensitive   = true
}

variable "webhook_auth_object_id" {
  type        = string
  description = "Object ID per AAD auth del webhook (opzionale)"
  default     = ""
}

variable "webhook_auth_tenant_id" {
  type        = string
  description = "Tenant ID per AAD auth del webhook (opzionale)"
  default     = ""
}

variable "webhook_auth_identifier_uri" {
  type        = string
  description = "Identifier URI per AAD auth del webhook (opzionale)"
  default     = ""
}

variable "email_receivers" {
  type        = list(object({ name = string, email = string }))
  description = "Destinatari email dell'action group"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tag delle risorse"
  default     = {}
}
