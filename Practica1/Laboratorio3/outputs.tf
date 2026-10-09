output "resource_group_name" {
  description = "Nombre del grupo de recursos del entorno QA."
  value       = azurerm_resource_group.qa.name
}

output "log_analytics_workspace_name" {
  description = "Nombre del espacio de trabajo de Log Analytics."
  value       = azurerm_log_analytics_workspace.qa.name
}

output "application_insights_name" {
  description = "Nombre del recurso de Application Insights."
  value       = azurerm_application_insights.qa.name
}

output "service_plan_name" {
  description = "Nombre del plan de servicio de la aplicación web."
  value       = azurerm_service_plan.qa.name
}

output "web_app_name" {
  description = "Nombre de la aplicación web Linux."
  value       = azurerm_linux_web_app.qa.name
}

output "web_app_url" {
  description = "URL pública (HTTPS) de la aplicación web."
  value       = "https://${azurerm_linux_web_app.qa.default_hostname}"
}
