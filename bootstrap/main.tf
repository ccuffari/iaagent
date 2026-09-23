# Bootstrap dei backend di state Terraform.
#
# NOTA: lo state di uat e prod e' stato UNIFICATO sullo storage di dev
# (sttfstatedevwe01, container 'tfstate', key 'uat/' e 'prod/').
# Non servono piu' storage di state dedicati per uat/prod.
#
# Questo ambiente resta come riferimento storico; i moduli tfstate_uat e
# tfstate_prod sono stati rimossi perche' non piu' necessari.

locals {
  location = "westeurope"
  tags = {
    purpose    = "terraform-state"
    managed_by = "terraform"
    owner      = "Cristian Felice Cuffari"
    project    = "ia_agent"
  }
}
