terraform {
  backend "azurerm" {
    # Configurazione parziale: i valori reali sono passati via -backend-config
    # dalla pipeline CI/CD (vedi .github/workflows/terraform-dev.yml).
    use_azuread_auth = true
  }
}
