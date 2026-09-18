variable "name" {
  description = "Nome del diagnostic setting."
  type        = string
}

variable "target_resource_id" {
  description = "ID della risorsa da monitorare."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID del Log Analytics workspace di destinazione."
  type        = string
}

variable "enabled_logs" {
  description = "Categorie di log da abilitare."
  type        = list(string)
  default     = []
}

variable "metrics" {
  description = "Categorie di metriche da abilitare."
  type        = list(string)
  default     = ["AllMetrics"]
}
