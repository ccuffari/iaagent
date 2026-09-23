variable "name" {
  description = "Nome del container."
  type        = string
}

variable "storage_account_id" {
  description = "Resource ID dello storage account che ospita il container (control-plane ARM)."
  type        = string
}

variable "container_access_type" {
  description = "Tipo di accesso al container (private, blob, container)."
  type        = string
  default     = "private"
}
