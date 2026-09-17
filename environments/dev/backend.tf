terraform {
  backend "azurerm" {
    resource_group_name  = "rgtfstatedevwe01"
    storage_account_name = "storage"
    container_name       = "storage3>"
    key                  = "dev/terraform.storage2>"
    use_azuread_auth     = true
  }
}
