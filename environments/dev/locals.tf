data "azurerm_client_config" "current" {}

locals {
  environment         = "dev"
  location            = "westeurope"
  resource_group_name = "rg-ai-dev-we-01"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
