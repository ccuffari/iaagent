terraform {
  backend "azurerm" {
    resource_group_name  = "rg-we-aura-01"
    storage_account_name = "storage"
    container_name       = "<storage2>"
    key                  = "dev/terraform.tfstate"
    use_azuread_auth     = true
  }
}
