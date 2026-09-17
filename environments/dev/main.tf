module "storage_account" {
  source = "../../modules/storage_account"

  name                     = "saiaagentdevwe01"
  resource_group_name      = "iacrgtestwe01"
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}
