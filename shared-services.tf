#---------------------------
# Local declarations
#---------------------------

locals {
  prefix-sharedServices = "sharedServices${var.name}"
}

#--------------------------------------------
# Create resource group
#--------------------------------------------
resource "azurerm_resource_group" "shared_vnet_rg" {
  name     = "rg-networks-${local.prefix-sharedServices}-${random_string.random.result}-001"
  location = var.location
  tags     = local.common_tags
}

#---------------------------
# Create networks
#---------------------------

module "shared_vnet" {
  source = "./modules/networks/az_vnet"

  vnet_name           = "vnet-${local.prefix-sharedServices}-001"
  resource_group_name = azurerm_resource_group.shared_vnet_rg.name
  location            = azurerm_resource_group.shared_vnet_rg.location
  address_space       = var.sharedServices_address_space # Add the address space for the vnet
  tags                = local.common_tags

  subnets = var.sharedServices_subnet
}


# ------------------Hub vnet peering------------------
resource "azurerm_virtual_network_peering" "sharedServices-hub-peer" {
  name                      = "sharedServices-hub-peer"
  resource_group_name       = azurerm_resource_group.shared_vnet_rg.name
  virtual_network_name      = module.shared_vnet.virtual_network_name
  remote_virtual_network_id = module.hub_vnet.virtual_network_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub-sharedServices-peer" {
  name                      = "hub-sharedServices-peer"
  resource_group_name       = azurerm_resource_group.hub_vnet_rg.name
  virtual_network_name      = module.hub_vnet.virtual_network_name
  remote_virtual_network_id = module.shared_vnet.virtual_network_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# ------------------spoke1 vnet peering------------------
resource "azurerm_virtual_network_peering" "sharedServices-spoke1-peer" {
  name                      = "sharedServices-spoke1-peer"
  resource_group_name       = azurerm_resource_group.shared_vnet_rg.name
  virtual_network_name      = module.shared_vnet.virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.spoke1-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke1-sharedServices-peer" {
  name                      = "spoke1-sharedServices-peer"
  resource_group_name       = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke1-vnet.name
  remote_virtual_network_id = module.shared_vnet.virtual_network_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}


# ------------------Shared Services AGW------------------
resource "azurerm_public_ip" "agw_pip" {
  name                = "pip-${local.prefix-sharedServices}-001"
  resource_group_name = azurerm_resource_group.shared_vnet_rg.name
  location            = azurerm_resource_group.shared_vnet_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

resource "azurerm_application_gateway" "sharedServices_agw" {
  name                = "agw-${local.prefix-sharedServices}-001"
  resource_group_name = azurerm_resource_group.shared_vnet_rg.name
  location            = azurerm_resource_group.shared_vnet_rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = module.shared_vnet.subnet_id["snet-appgateway"]
  }

  frontend_port {
    name = "test-feport"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "test-feip"
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  backend_address_pool {
    name = "test-beap"
    ip_addresses = azurerm_linux_virtual_machine.spoke1-vm.private_ip_addresses
  }

  backend_http_settings {
    name                  = "test-be-htst"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "test-httplstn"
    frontend_ip_configuration_name = "test-feip"
    frontend_port_name             = "test-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "test-rqrt"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "test-httplstn"
    backend_address_pool_name  = "test-beap"
    backend_http_settings_name = "test-be-htst"
  }
}