variable "name" {
  description = "Nome del budget."
  type        = string
}

variable "resource_group_id" {
  description = "ID del resource group a cui applicare il budget."
  type        = string
}

variable "amount" {
  description = "Importo del budget (nella valuta della subscription)."
  type        = number
}

variable "time_grain" {
  description = "Granularita' del budget (Monthly, Quarterly, Annually)."
  type        = string
  default     = "Monthly"
}

variable "start_date" {
  description = "Data di inizio del periodo (RFC3339, primo del mese)."
  type        = string
}

variable "contact_emails" {
  description = "Email di notifica del budget."
  type        = list(string)
}

variable "notifications" {
  description = "Soglie di notifica del budget."
  type = list(object({
    threshold      = number
    operator       = string
    threshold_type = string
  }))
  default = []
}
