# Input del modulo resource_group

variable "name" {
  description = "Nome del resource group"
  type        = string
}

variable "location" {
  description = "Regione Azure (es. westeurope)"
  type        = string
}

variable "tags" {
  description = "Tag da applicare alle risorse"
  type        = map(string)
  default     = {}
}
