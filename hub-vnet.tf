#---------------------------
# Local declarations
#---------------------------

locals {
  prefix-hub = "hub"

  # Tagging locals
  common_tags = {
    project_name = "azure-lz"      # Set a project tag, such as "john-dev-linuxvm"
    environment  = var.environment # Set an environment tag, such as "development"
    #contact     = "" # Set contact information for the deployment, such as "john.doe@mail.com"
  }
}

#--------------------------------------------
# Create resource group and random string
#--------------------------------------------

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "hub_vnet_rg" {
  name     = "rg-${local.prefix-hub}-networks-${random_string.random.result}-001"
  location = var.location
  tags     = local.common_tags
}


#---------------------------
# Create networks
#---------------------------

module "hub_vnet" {
  source = "./modules/networks/az_vnet"

  vnet_name           = "vnet-${local.prefix-hub}-001"
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  location            = azurerm_resource_group.hub_vnet_rg.location
  address_space       = var.address_space # Add the address space for the vnet
  tags                = local.common_tags

  subnets = var.hub_subnet
}
