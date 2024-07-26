output "pip_id" {
  description = "The ID of the public IP"
  value       = azurerm_public_ip.pip.id
}

output "ip_address" {
  description = "The IP address of the public IP"
  value       = azurerm_public_ip.pip.ip_address
}