module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "rg-ai-dev-we-01"
  location = local.location
  tags     = local.tags
}
