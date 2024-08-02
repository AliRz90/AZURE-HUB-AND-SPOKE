resource "azurerm_public_ip" "pip" {
  name                = var.pip-name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku                 = "Standard"
  zones               = var.zones

  tags = var.tags
}