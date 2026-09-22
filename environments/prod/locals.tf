data "azurerm_client_config" "current" {}

locals {
  environment = "prod"
  location    = "westeurope"
  workload    = "ai"
  region      = "we"
  instance    = "01"

  # Suffisso comune per la naming convention: workload-env-region-instance
  suffix = "${local.workload}-${local.environment}-${local.region}-${local.instance}"

  # Nomi risorse (naming convention Azure).
  resource_group_name = "rg-${local.suffix}"
  vnet_name           = "vnet-${local.suffix}"
  subnet_name         = "subnet-${local.suffix}"
  # Storage account: senza trattini.
  storage_account_name    = "sa${local.workload}${local.environment}${local.region}${local.instance}"
  storage_account_02_name = "sa${local.workload}${local.environment}${local.region}02"
  data_factory_name       = "adf-${local.suffix}"
  # Key Vault: nome globalmente unico; 'kv-ai-prod-we-01' risulta occupato/soft-deleted,
  # si usa l'istanza 02.
  key_vault_name          = "kv-${local.workload}-${local.environment}-${local.region}-02"
  log_analytics_name      = "log-${local.suffix}"
  sql_server_name         = "sql-${local.suffix}"
  sql_database_name       = "sql-db-${local.suffix}"
  budget_name             = "budget-${local.suffix}"

  tenant_id = data.azurerm_client_config.current.tenant_id
  tags = {
    environment = local.environment
    managed_by  = "terraform"
  }
}
