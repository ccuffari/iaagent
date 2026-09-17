module "rg_rg-ia-dev-we-01" {
  source   = "../../modules/resource_group"
  name     = "rg-ia-dev-we-01"
  location = local.location
  tags     = local.tags
}
