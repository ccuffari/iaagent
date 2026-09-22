variable "name" {
  description = "Nome dello storage account per lo state Terraform (senza trattini)."
  type        = string
}

variable "resource_group_name" {
  description = "Nome del resource group che ospita lo state."
  type        = string
}

variable "location" {
  description = "Regione Azure."
  type        = string
}

variable "container_name" {
  description = "Nome del container per lo state."
  type        = string
  default     = "tfstate"
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
