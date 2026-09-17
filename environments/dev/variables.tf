variable "allowed_ip_addresses" {
  description = "ACL esplicite: IP pubblici autorizzati ad accedere a Storage/KeyVault (es. runner CI/CD). Vuoto = solo VNet."
  type        = list(string)
  default     = []
}
