output "virtual_network_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the vnet"
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Output ID of the deployed Resource"
}

output "subnet_id" {
  value = { for k, v in azurerm_subnet.subnet : k => v.id }
}
