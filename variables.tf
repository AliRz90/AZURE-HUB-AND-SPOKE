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
# Network Variables
#---------------------------
variable "address_space" {
  description = "The address space for the vnet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "hub_subnet" {
  description = "The address prefixes for the subnets"
  type        = map(list(string))
  default = {
    AzureFirewallSubnet           = ["10.0.0.0/26"]
    #AzureFirewallManagementSubnet = ["10.0.0.64/26"]
    GatewaySubnet                 = ["10.0.0.128/27"]
    ManagementSubnet              = ["10.0.1.0/24"]
  }
}
