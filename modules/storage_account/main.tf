resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = "TLS1_2"
  tags                     = var.tags

  network_rules {
    default_action             = var.network_default_action
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = var.allowed_subnet_ids
    ip_rules                   = var.allowed_ip_addresses
  }
}
