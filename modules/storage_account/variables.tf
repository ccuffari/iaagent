# Input del modulo storage_account

variable "name" {
  description = "Nome dello storage account (lowercase, senza dash)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group di destinazione"
  type        = string
}

variable "location" {
  description = "Regione Azure"
  type        = string
}

variable "account_tier" {
  description = "Tier dello storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Tipo di replica"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tag da applicare"
  type        = map(string)
  default     = {}
}
