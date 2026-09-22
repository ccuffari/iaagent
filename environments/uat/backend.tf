terraform {
  backend "azurerm" {
    resource_group_name  = "rgtfstateuatwe01"
    storage_account_name = "sttfstateuatwe01"
    container_name       = "tfstate"
    key                  = "uat/terraform.tfstate"
    use_azuread_auth     = true
  }
}
