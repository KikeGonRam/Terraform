variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
  default     = null
  sensitive   = true
}


variable "service_plan_sku_name" {
  type    = string
  default = "F1"
}

variable "application_type" {
  description = "Application type for the Azure Application Insights resource"
  type        = string
  default     = "web"
}

variable "node_version" {
  description = "Node.js version for the Azure Linux Web App"
  type        = string
  default     = "24-lts"
}

variable "log_analytics_sku" {
  description = "SKU del espacio de trabajo de Log Analytics"
  type        = string
  default     = "PerGB2018"
}


variable "web_app_name" {
  description = "Nombre de la aplicación web del entorno QA"
  type        = string
  default     = "app-utvt-integradora-web-qa-mxc-001"
}
