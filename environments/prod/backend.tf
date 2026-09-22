terraform {
  backend "azurerm" {
    resource_group_name  = "rgtfstateprodwe01"
    storage_account_name = "sttfstateprodwe01"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
    use_azuread_auth     = true
  }
}
