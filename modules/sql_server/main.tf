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
  tags                         = var.tags
}
