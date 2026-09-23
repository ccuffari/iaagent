terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_databricks_workspace" "existing" {
  name                = local.databricks_name
  resource_group_name = local.resource_group_name
}

provider "databricks" {
  host = "https://${data.azurerm_databricks_workspace.existing.workspace_url}"
}
