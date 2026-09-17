module "rg-ia-dev-we-01" {
  source   = "../../modules/rg-ia-dev-we-01"
  name     = "rg-ia-dev-we-01"
  location = local.location
  tags     = local.tags
}
