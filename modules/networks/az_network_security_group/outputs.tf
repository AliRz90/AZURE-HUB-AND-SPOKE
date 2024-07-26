output "network_security_group_id" {
  description = "The ID of the NIC"
  value       = azurerm_network_security_group.nsg.id
}