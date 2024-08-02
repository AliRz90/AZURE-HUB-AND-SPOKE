#---------------------------
# Local declarations
#---------------------------

locals {
  prefix-hub = "hub-${var.name}"

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
  name     = "rg-networks-${local.prefix-hub}-${random_string.random.result}-001"
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
  address_space       = var.hub_address_space # Add the address space for the vnet
  tags                = local.common_tags

  subnets = var.hub_subnet
}

# -----------------UDR-------------------------
# spoke 1 UDR
resource "azurerm_route_table" "spoke1-rt" {
  name                          = "spoke1-rt"
  location                      = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name           = azurerm_resource_group.spoke1-vnet-rg.name
  bgp_route_propagation_enabled = false

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
  }

  #route {
  #  name                   = "toAGW"
  #  address_prefix         = "10.1.0.0/24"
  #  next_hop_type          = "VirtualAppliance"
  #  next_hop_in_ip_address = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
  #}

  tags = local.common_tags
}

resource "azurerm_subnet_route_table_association" "spoke1-rt-spoke1-vnet-mgmt" {
  subnet_id      = azurerm_subnet.spoke1-mgmt.id
  route_table_id = azurerm_route_table.spoke1-rt.id
}
