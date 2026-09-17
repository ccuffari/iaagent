data "azurerm_key_vault_secret" "admin_login" {
  name         = var.admin_login_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password_secret_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_mssql_server" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.admin_login.value
  administrator_login_password = data.azurerm_key_vault_secret.admin_password.value
  public_network_access_enabled = true
  tags                         = var.tags
}

# Blocca tutto il traffico pubblico (0.0.0.0-0.0.0.0 = deny all)
resource "azurerm_mssql_firewall_rule" "deny_all_public" {
  name             = "DenyAllPublic"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Consente l'accesso solo dalla subnet della VNet
resource "azurerm_mssql_virtual_network_rule" "vnet" {
  count     = var.subnet_id == null ? 0 : 1
  name      = "AllowVNet"
  server_id = azurerm_mssql_server.this.id
  subnet_id = var.subnet_id
}
