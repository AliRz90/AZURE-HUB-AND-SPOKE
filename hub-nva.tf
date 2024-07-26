#---------------------------
# Local declarations
#---------------------------

locals {
  prefix-hub-nva = "hub-nva"
}

#---------------------------
# Create nva
#---------------------------

resource "azurerm_public_ip" "fw_pip_1" {
  name                = "pip-${local.prefix-hub}-001"
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  location            = azurerm_resource_group.hub_vnet_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

#resource "azurerm_public_ip" "fw_pip_2" {
#  name                = "pip-${local.prefix-hub}-002"
#  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
#  location            = azurerm_resource_group.hub_vnet_rg.location
#  allocation_method   = "Static"
#  sku                 = "Standard"
#
#  tags = local.common_tags
#}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = "fw-hub-policy-001"
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  location            = azurerm_resource_group.hub_vnet_rg.location
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_firewall" "hub_fw" {
  name                = "fw${local.prefix-hub}-001"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  tags                = local.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.hub_vnet.subnet_id["AzureFirewallSubnet"]
    public_ip_address_id = azurerm_public_ip.fw_pip_1.id
  }

  #management_ip_configuration {
  #  name                 = "mgmt-config"
  #  subnet_id            = module.hub_vnet.subnet_id["AzureFirewallManagementSubnet"]
  #  public_ip_address_id = azurerm_public_ip.fw_pip_2.id
  #}
}
