resource "azurerm_mssql_server" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.admin_login
  administrator_login_password  = var.admin_password
  public_network_access_enabled = true
  tags                          = var.tags

  lifecycle {
    ignore_changes = [
      administrator_login,
      administrator_login_password,
    ]
  }
}

# Blocca tutto il traffico pubblico (0.0.0.0-0.0.0.0 = deny all)
resource "azurerm_mssql_firewall_rule" "deny_all_public" {
  name             = "DenyAllPublic"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Consente l'accesso solo dalla subnet della VNet.
# Usa for_each (chiave nota) invece di count: il count dipenderebbe da
# var.subnet_id, che e' "known after apply" e causerebbe l'errore
# "Invalid count argument".
resource "azurerm_mssql_virtual_network_rule" "vnet" {
  for_each = var.enable_vnet_rule ? { "vnet" = var.subnet_id } : {}

  name      = "AllowVNet"
  server_id = azurerm_mssql_server.this.id
  subnet_id = each.value
}
