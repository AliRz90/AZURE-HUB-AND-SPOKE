variable "vnet_name" {
  description = "Name of the resource deployment, i.e vnet/rg/kv"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the deployment"
  type        = string
}

variable "location" {
  description = "The Azure Region to use"
  type        = string
}

variable "address_space" {
  description = "The address space for the Vnet"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets to create"
  type        = map(list(string))
}

# Tagging variables
variable "tags" {
  description = "Default tags"
  type        = map(string)
}