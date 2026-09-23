terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.15"
    }
  }
}

# Container gestito via CONTROL-PLANE ARM (azapi) invece del data-plane (azurerm).
# Motivo: lo storage account ha network_rules.default_action = "Deny" con firewall;
# il data-plane (azurerm_storage_container) viene bloccato con 403 AuthorizationFailure
# dal runner CI/CD (IP non in allowlist). Il control-plane ARM NON passa dal firewall
# data-plane, quindi azapi funziona anche con lo storage chiuso.
resource "azapi_resource" "this" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01"
  name      = var.name
  parent_id = "${var.storage_account_id}/blobServices/default"

  body = jsonencode({
    properties = {
      publicAccess = var.container_access_type == "private" ? "None" : var.container_access_type
    }
  })
}
