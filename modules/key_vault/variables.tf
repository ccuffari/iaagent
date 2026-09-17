# Input del modulo key_vault

variable "name" {
  description = "Nome del Key Vault"
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

variable "sku_name" {
  description = "SKU del Key Vault"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tag da applicare"
  type        = map(string)
  default     = {}
}
