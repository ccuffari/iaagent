# Diagnostic settings: collega le risorse del RG rg-ai-dev-we-01 al Log Analytics log-ai-dev-we-01.
# Workaround temporaneo (opzione B): file autonomo, non modifica i moduli esistenti.
# NB: la VNet NON supporta diagnostic settings (serve NSG Flow Logs -> Storage Account).

data "azurerm_log_analytics_workspace" "this" {
  name                = "log-ai-dev-we-01"
  resource_group_name = "rg-ai-dev-we-01"
}

data "azurerm_storage_account" "this" {
  name                = "saaidevwe01"
  resource_group_name = "rg-ai-dev-we-01"
}

data "azurerm_data_factory" "this" {
  name                = "adf-ai-dev-we-01"
  resource_group_name = "rg-ai-dev-we-01"
}

data "azurerm_key_vault" "this" {
  name                = "kv-ai-agent-dev-we-01"
  resource_group_name = "rg-ai-dev-we-01"
}

data "azurerm_mssql_server" "this" {
  name                = "sql-ai-dev-we-01"
  resource_group_name = "rg-ai-dev-we-01"
}

data "azurerm_mssql_database" "this" {
  name      = "sql-db-ai-dev-we-01"
  server_id = data.azurerm_mssql_server.this.id
}

# --- Storage Account: metriche account-level ---
resource "azurerm_monitor_diagnostic_setting" "storage_account" {
  name                       = "diag-storage-account"
  target_resource_id         = data.azurerm_storage_account.this.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  metric {
    category = "AllMetrics"
  }
}

# --- Storage Account: log Blob (StorageRead/Write/Delete) ---
resource "azurerm_monitor_diagnostic_setting" "storage_blob" {
  name                       = "diag-storage-blob"
  target_resource_id         = "${data.azurerm_storage_account.this.id}/blobServices/default"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
  enabled_log {
    category = "StorageDelete"
  }
  metric {
    category = "AllMetrics"
  }
}

# --- Data Factory: run pipeline/activity/trigger + metriche ---
resource "azurerm_monitor_diagnostic_setting" "adf" {
  name                       = "diag-adf"
  target_resource_id         = data.azurerm_data_factory.this.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "PipelineRuns"
  }
  enabled_log {
    category = "ActivityRuns"
  }
  enabled_log {
    category = "TriggerRuns"
  }
  metric {
    category = "AllMetrics"
  }
}

# --- Key Vault: audit eventi + metriche ---
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-keyvault"
  target_resource_id         = data.azurerm_key_vault.this.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "AuditEvent"
  }
  metric {
    category = "AllMetrics"
  }
}

# --- SQL Server: metriche ---
resource "azurerm_monitor_diagnostic_setting" "sql_server" {
  name                       = "diag-sqlserver"
  target_resource_id         = data.azurerm_mssql_server.this.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  metric {
    category = "AllMetrics"
  }
}

# --- SQL Database: log query/errori + metriche ---
resource "azurerm_monitor_diagnostic_setting" "sql_database" {
  name                       = "diag-sqldb"
  target_resource_id         = data.azurerm_mssql_database.this.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "SQLInsights"
  }
  enabled_log {
    category = "Errors"
  }
  enabled_log {
    category = "Timeouts"
  }
  enabled_log {
    category = "Blocks"
  }
  enabled_log {
    category = "Deadlocks"
  }
  enabled_log {
    category = "QueryStoreRuntimeStatistics"
  }
  enabled_log {
    category = "QueryStoreWaitStatistics"
  }
  enabled_log {
    category = "DatabaseWaitStatistics"
  }
  metric {
    category = "AllMetrics"
  }
}
