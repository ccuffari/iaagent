terraform {
  backend "azurerm" {
    resource_group_name  = "iacrgtestwe01"
    storage_account_name = "staiagentwe01"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
    use_azuread_auth     = true
  }
}
