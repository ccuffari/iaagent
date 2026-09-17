terraform {
  backend "azurerm" {
    resource_group_name  = "rgtfstatedevwe01"
    storage_account_name = "sttfstatedevwe01"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
    use_azuread_auth     = true
  }
}
