module "resource_group" {
  source = "../../modules/resource_group"
  name                       = "rgiadevwe01"
  location                   = "westeurope"
  tags                       = local.tags
}
