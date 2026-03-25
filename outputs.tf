output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.rg.name
}

output "vm_name" {
  description = "The name of the Linux virtual machine."
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_id" {
  description = "The ID of the Linux virtual machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_identity_principal_id" {
  description = "The principal ID of the VM's identity. If SystemAssigned is used, this will be the VM's principal ID."
  value       = try(azurerm_linux_virtual_machine.vm.identity[0].principal_id, null)
}

output "private_ip_address" {
  description = "The private IP address of the VM."
  value       = azurerm_network_interface.networkInterface0.private_ip_address
}

output "public_ip_address" {
  description = "The public IP address of the VM (if assigned)."
  value       = try(azurerm_public_ip.publicIp1[0].ip_address, null)
}

output "private_nic_id" {
  description = "The ID of the private network interface."
  value       = azurerm_network_interface.networkInterface0.id
}

