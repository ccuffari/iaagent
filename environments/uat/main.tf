# =============================================================================
# AMBIENTE UAT - DISMESSO
# =============================================================================
# Tutti i moduli sono COMMENTATI: l'ambiente uat e' stato dismesso.
# Al prossimo 'apply' Terraform DISTRUGGE tutte le risorse uat (RG, VNet,
# storage, ADF, Key Vault, Log Analytics, SQL Server+DB, budget, diagnostic).
#
# Per riattivare: decommentare i blocchi e rilanciare l'apply.
# =============================================================================

# module "resource_group" {
#   source   = "../../modules/resource_group"
#   name     = local.resource_group_name
#   location = local.location
#   tags     = local.tags
# }
#
# module "virtual_network" {
#   source              = "../../modules/virtual_network"
#   name                = local.vnet_name
#   resource_group_name = module.resource_group.name
#   location            = local.location
#   address_space       = ["10.0.0.0/16"]
#   subnet_name         = local.subnet_name
#   subnet_prefixes     = ["10.0.1.0/24"]
#   service_endpoints   = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql"]
#   tags                = local.tags
# }
#
# module "storage_account" {
#   source                   = "../../modules/storage_account"
#   name                     = local.storage_account_name
#   resource_group_name      = module.resource_group.name
#   location                 = local.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   network_default_action   = "Deny"
#   allowed_subnet_ids       = [module.virtual_network.subnet_id]
#   allowed_ip_addresses     = var.allowed_ip_addresses
#   tags                     = local.tags
# }
#
# module "storage_account_02" {
#   source                   = "../../modules/storage_account"
#   name                     = local.storage_account_02_name
#   resource_group_name      = module.resource_group.name
#   location                 = local.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   network_default_action   = "Deny"
#   allowed_subnet_ids       = [module.virtual_network.subnet_id]
#   allowed_ip_addresses     = var.allowed_ip_addresses
#   tags                     = local.tags
# }
#
# module "data_factory" {
#   source              = "../../modules/data_factory"
#   name                = local.data_factory_name
#   resource_group_name = module.resource_group.name
#   location            = local.location
#   tags                = local.tags
# }
#
# module "key_vault" {
#   source                 = "../../modules/key_vault"
#   name                   = local.key_vault_name
#   resource_group_name    = module.resource_group.name
#   location               = local.location
#   tenant_id              = local.tenant_id
#   sku_name               = "standard"
#   network_default_action = "Deny"
#   allowed_subnet_ids     = [module.virtual_network.subnet_id]
#   allowed_ip_addresses   = var.allowed_ip_addresses
#   tags                   = local.tags
# }
#
# module "log_analytics" {
#   source              = "../../modules/log_analytics"
#   name                = local.log_analytics_name
#   resource_group_name = module.resource_group.name
#   location            = local.location
#   tags                = local.tags
# }
#
# module "sql_server" {
#   source              = "../../modules/sql_server"
#   name                = local.sql_server_name
#   resource_group_name = module.resource_group.name
#   location            = local.location
#   admin_login         = var.sql_admin_login
#   admin_password      = var.sql_admin_password
#   subnet_id           = module.virtual_network.subnet_id
#   enable_vnet_rule    = true
#   tags                = local.tags
# }
#
# module "sql_database" {
#   source    = "../../modules/sql_database"
#   name      = local.sql_database_name
#   server_id = module.sql_server.id
#   sku_name  = "S0"
# }
#
# # --- Azure Purview (data governance) ---
# # TEMPORANEAMENTE COMMENTATO: il codice del modulo resta nel repo, ma la risorsa
# # viene rimossa da Azure al prossimo apply (Terraform distrugge cio' che non e'
# # piu' dichiarato). Per riattivare: decommentare il blocco e rilanciare l'apply.
# #
# # module "purview" {
# #   source              = "../../modules/purview"
# #   name                = "pvw-${local.suffix}"
# #   resource_group_name = module.resource_group.name
# #   location            = local.location
# #   tags                = local.tags
# #
# #   role_assignments = {
# #     rg_reader = {
# #       scope = module.resource_group.id
# #       role  = "Reader"
# #     }
# #     storage01_blob_reader = {
# #       scope = module.storage_account.id
# #       role  = "Storage Blob Data Reader"
# #     }
# #     storage02_blob_reader = {
# #       scope = module.storage_account_02.id
# #       role  = "Storage Blob Data Reader"
# #     }
# #     adf_contributor = {
# #       scope = module.data_factory.id
# #       role  = "Data Factory Contributor"
# #     }
# #   }
# # }
#
# # --- Budget + alerting cost ---
# module "budget" {
#   source            = "../../modules/budget"
#   name              = local.budget_name
#   resource_group_id = module.resource_group.id
#   amount            = var.budget_amount
#   start_date        = var.budget_start_date
#   contact_emails    = var.budget_contact_emails
#   notifications = [
#     { threshold = 50, operator = "GreaterThan", threshold_type = "Actual" },
#     { threshold = 80, operator = "GreaterThan", threshold_type = "Actual" },
#     { threshold = 100, operator = "GreaterThan", threshold_type = "Actual" },
#   ]
# }
#
# # --- Diagnostic settings (modulo riutilizzabile) ---
# # NOTA: diag_storage_blob NON e' gestito da Terraform: il provider azurerm va in
# # timeout su blobServices/default (bug noto). La risorsa puo' essere creata a
# # parte (es. via azapi o manualmente) senza impattare il deploy.
# module "diag_storage_account" {
#   source                     = "../../modules/diagnostic_settings"
#   name                       = "diag-storage-account"
#   target_resource_id         = module.storage_account.id
#   log_analytics_workspace_id = module.log_analytics.id
#   metrics                    = ["AllMetrics"]
# }
#
# module "diag_storage_account_02" {
#   source                     = "../../modules/diagnostic_settings"
#   name                       = "diag-storage-account-02"
#   target_resource_id         = module.storage_account_02.id
#   log_analytics_workspace_id = module.log_analytics.id
#   metrics                    = ["AllMetrics"]
# }
#
# module "diag_adf" {
#   source                     = "../../modules/diagnostic_settings"
#   name                       = "diag-adf"
#   target_resource_id         = module.data_factory.id
#   log_analytics_workspace_id = module.log_analytics.id
#   enabled_logs               = ["PipelineRuns", "ActivityRuns", "TriggerRuns"]
#   metrics                    = ["AllMetrics"]
# }
#
# module "diag_key_vault" {
#   source                     = "../../modules/diagnostic_settings"
#   name                       = "diag-keyvault"
#   target_resource_id         = module.key_vault.id
#   log_analytics_workspace_id = module.log_analytics.id
#   enabled_logs               = ["AuditEvent"]
#   metrics                    = ["AllMetrics"]
# }
#
# module "diag_sql_server" {
#   source                     = "../../modules/diagnostic_settings"
#   name                       = "diag-sqlserver"
#   target_resource_id         = module.sql_server.id
#   log_analytics_workspace_id = module.log_analytics.id
#   metrics                    = ["AllMetrics"]
# }
#
# module "diag_sql_database" {
#   source                     = "../../modules/diagnostic_settings"
#   name                       = "diag-sqldb"
#   target_resource_id         = module.sql_database.id
#   log_analytics_workspace_id = module.log_analytics.id
#   enabled_logs = [
#     "SQLInsights",
#     "Errors",
#     "Timeouts",
#     "Blocks",
#     "Deadlocks",
#     "QueryStoreRuntimeStatistics",
#     "QueryStoreWaitStatistics",
#     "DatabaseWaitStatistics",
#   ]
#   metrics = ["AllMetrics"]
# }
