#----------------------------------------------------------
# General Variables
#----------------------------------------------------------

variable "location" {
  description = "The Azure Region in which all resources will be deployed"
  default     = "northeurope"
}

variable "environment" {
  description = "The environment in which the resources will be deployed"
  default     = "dev"
}

variable "name" {
  description = "The name of the resource group"
  type        = string
  default     = "NovaPlexCloud"
}

#---------------------------
# Hub Network Variables
#---------------------------
variable "hub_address_space" {
  description = "The address space for the vnet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "hub_subnet" {
  description = "The address prefixes for the subnets"
  type        = map(list(string))
  default = {
    AzureFirewallSubnet = ["10.0.0.0/26"]
    AGSSubnet           = ["10.0.1.0/24"]
    ManagementSubnet    = ["10.0.2.0/24"]
  }
}

#---------------------------
# SharedServices Network Variables
#---------------------------

variable "sharedServices_address_space" {
  description = "The address space for the vnet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "sharedServices_subnet" {
  description = "The address prefixes for the subnets"
  type        = map(list(string))
  default = {
    snet-appgateway = ["10.1.0.0/24"]
  }
}

#---------------------------
# Spoke1 VM Variables
#---------------------------
variable "username" {
  description = "Username for Virtual Machines"
  default     = "azureuser"
}

variable "password" {
  description = "Password for Virtual Machines"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2s"
}
