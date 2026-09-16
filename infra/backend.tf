terraform {
  backend "azurerm" {
    resource_group_name  = "rg-we-aura-01"
    storage_account_name = "staiagentwe01"
    container_name       = "tfstate"
    key                  = "demo.tfstate"
  }
}
