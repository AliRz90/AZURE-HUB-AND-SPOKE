#----------------------------------------------------------
# General Variables
#----------------------------------------------------------

variable "location" {
  description = "The Azure Region in which all resources will be deployed"
  type        = string
}

variable "environment" {
  description = "The environment in which the resources will be deployed"
  type        = string
}

variable "name" {
  description = "The name of the resource group"
  type        = string

}

variable "app_name" {
  description = "The application name"
  type        = string
}

#---------------------------
# Hub Network Variables
#---------------------------
variable "hub_address_space" {
  description = "The address space for the vnet"
  type        = list(string)

}

variable "hub_subnet" {
  description = "The address prefixes for the subnets"
  type        = map(list(string))

}

#---------------------------
# SharedServices Network Variables
#---------------------------

variable "sharedServices_address_space" {
  description = "The address space for the vnet"
  type        = list(string)

}

variable "sharedServices_subnet" {
  description = "The address prefixes for the subnets"
  type        = map(list(string))

}

#---------------------------
# Spoke1 VM Variables
#---------------------------

variable "username" {
  description = "Username for Virtual Machines"
  type        = string

}

variable "password" {
  description = "Password for Virtual Machines"
  type        = string
}

variable "vmsize" {
  description = "Size of the VMs"
  type        = string

}
