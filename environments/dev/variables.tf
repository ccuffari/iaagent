variable "allowed_ip_addresses" {
  description = "ACL esplicite: IP pubblici autorizzati ad accedere a Storage/KeyVault (es. runner CI/CD). Vuoto = solo VNet."
  type        = list(string)
  default     = []
}

variable "sql_admin_login" {
  description = "Login admin SQL Server (da GitHub secret TF_VAR_sql_admin_login)"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "Password admin SQL Server (da GitHub secret TF_VAR_sql_admin_password)"
  type        = string
  sensitive   = true
}
