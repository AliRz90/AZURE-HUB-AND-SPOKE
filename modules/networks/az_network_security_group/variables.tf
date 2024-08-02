# General variables
variable "name" {
  description = "Name of the resource deployment, i.e vnet/rg/kv"

  type = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the deployment"
  type        = string

}

variable "location" {
  description = "The Azure Region to use"
  type        = string
}

variable "nsg_rules" {
  type = list(object({
    direction                                  = string
    name                                       = string
    priority                                   = number
    access                                     = string
    protocol                                   = string
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(list(string))
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    description                                = optional(string)
  }))
  default     = []
  description = "List of objects that represent the configuration of each inbound rule."
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
}