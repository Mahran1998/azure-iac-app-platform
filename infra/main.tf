resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location
}

module "network" {
  source           = "./modules/network"
  name_prefix      = var.name_prefix
  location         = var.location
  resource_group   = azurerm_resource_group.rg.name
  ssh_allowed_cidr = var.ssh_allowed_cidr
}

module "vm" {
  source         = "./modules/vm"
  name_prefix    = var.name_prefix
  location       = var.location
  resource_group = azurerm_resource_group.rg.name

  nic_id         = module.network.nic_id
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key

  app_image = var.app_image
}
