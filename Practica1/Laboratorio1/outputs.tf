output "enable_monitoring" {
  value = var.enable_monitoring
}

output "regions" {
  value = var.regions
}

output "environment_tags" {
  value = var.environment_tags
}

output "application_config" {
  value = var.aplication_config
}

output "allowed_networks" {
  value = var.allowed_networks
}

output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "vnet_name" {
  value = azurerm_virtual_network.example.name
}
