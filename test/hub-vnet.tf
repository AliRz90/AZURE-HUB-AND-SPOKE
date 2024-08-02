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

  custom_data = <<CUSTOM_DATA
#!/bin/bash
sudo apt update -y
sudo apt-get -y install nginx
sudo systemctl status nginx
CUSTOM_DATA
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.113"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

# Provider configuration
provider "azurerm" {
  features {}
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
  source = "../modules/networks/az_vnet"

  vnet_name           = "vnet-${local.prefix-hub}-001"
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  location            = azurerm_resource_group.hub_vnet_rg.location
  address_space       = var.hub_address_space # Add the address space for the vnet
  tags                = local.common_tags

  subnets = var.hub_subnet
}


# ------------- Hub VM ------------------
resource "azurerm_public_ip" "vm_pip" {
  name                = "pip-${local.prefix-hub}-vm-001"
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  location            = azurerm_resource_group.hub_vnet_rg.location
  allocation_method   = "Static"
  sku                 = "Basic"

  tags = local.common_tags
}

resource "azurerm_network_interface" "hub-nic" {
  name                  = "${local.prefix-hub}-nic-001"
  location              = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name   = azurerm_resource_group.hub_vnet_rg.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = local.prefix-hub
    subnet_id                     = module.hub_vnet.subnet_id["ManagementSubnet"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "spoke1-vm" {
  name                  = "${local.prefix-hub}-vm"
  location              = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name   = azurerm_resource_group.hub_vnet_rg.name
  network_interface_ids = [azurerm_network_interface.hub-nic.id]
  size                  = var.vmsize

  computer_name                   = "${local.prefix-hub}-vm"
  disable_password_authentication = false
  admin_username                  = var.username
  admin_password                  = var.password

  os_disk {
    name                 = "myosdisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(local.custom_data)
}
# -------------------Hub AGW----------------
