# Bootstrap dei backend di state Terraform per uat e prod.
#
# Questo ambiente e' SEPARATO dagli ambienti applicativi: crea i resource group
# e gli storage account che ospitano lo state remoto di uat/prod. Va applicato
# UNA TANTUM, prima di poter eseguire 'terraform init' su quegli ambienti.
#
# Lo state di questo bootstrap e' locale (non puo' stare su un backend che
# ancora non esiste).

locals {
  location = "westeurope"
  tags = {
    purpose    = "terraform-state"
    managed_by = "terraform"
  }
}

module "tfstate_uat" {
  source              = "../modules/tfstate_backend"
  name                = "sttfstateuatwe01"
  resource_group_name = "rgtfstateuatwe01"
  location            = local.location
  container_name      = "tfstate"
  tags                = local.tags
}

module "tfstate_prod" {
  source              = "../modules/tfstate_backend"
  name                = "sttfstateprodwe01"
  resource_group_name = "rgtfstateprodwe01"
  location            = local.location
  container_name      = "tfstate"
  tags                = local.tags
}
