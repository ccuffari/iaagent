module "resource_group" {
  source   = "../../modules/resource_group"
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

module "storage_account" {
  source               = "../../modules/storage_account"
  name                 = local.storage_account_name
  resource_group_name  = module.resource_group.name
  location             = local.location
  tags                 = local.tags
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = local.key_vault_name
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
}

module "data_factory" {
  source              = "../../modules/data_factory"
  name                = local.data_factory_name
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
}

module "sql_server" {
  source                     = "../../modules/sql_server"
  name                       = local.sql_server_name
  resource_group_name        = module.resource_group.name
  location                   = local.location
  key_vault_id               = module.key_vault.id
  admin_login_secret_name    = "sql-admin-login"
  admin_password_secret_name = "sql-admin-password"
  tags                       = local.tags
}

module "sql_database" {
  source    = "../../modules/sql_database"
  name      = local.sql_database_name
  server_id = module.sql_server.id
  sku_name  = "GP_S_Gen5_1"
}
