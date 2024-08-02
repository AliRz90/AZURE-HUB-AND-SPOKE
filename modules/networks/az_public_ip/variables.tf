# General variables
variable "location" {
  description = "The Azure Region to use"
  type        = string
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
}

# Resource-specific variables: 
variable "resource_group_name" {
  description = "The name of the resource group for the deployment"
  type        = string
}

variable "pip-name" {
  description = "Name of the resource deployment, i.e vnet/rg/kv"
  type        = string
}

variable "allocation_method" {
  description = "Should the IP be Static or Dyanamic"
  type        = string
}

variable "zones" {
  description = "The Availability Zones for the Public IP"
  type        = list(string)
}