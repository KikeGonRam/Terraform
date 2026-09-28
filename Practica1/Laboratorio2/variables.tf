variable "project_name" {
  description = "Nombre del proyecto."
  type        = string

  validation {
    condition     = length(var.project_name) >= 5 && length(var.project_name) <= 20
    error_message = "La variable project_name debe tener entre 5 y 20 caracteres."
  }
}

variable "environment" {
  description = "Ambiente de despliegue (dev, test, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "El ambiente debe ser 'dev', 'test' o 'prod'."
  }
}

variable "location" {
  description = "Región de Azure donde se desplegarán los recursos."
  type        = string
  default     = "Central Mexico"
}

variable "vnet_address_space" {
  description = "Espacio de direcciones para la red virtual."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Mapa de etiquetas para los recursos."
  type        = map(string)
  default = {
    managed_by  = "terraform"
    owner       = "it"
    cost_center = "utvt"
  }
}

variable "subscription_id" {
  description = "ID de la suscripción de Azure."
  type        = string
  default     = "a1057d7f-0b0b-4735-81ed-1c67fed4aabb" # Reemplaza con tu ID de suscripción real
  sensitive   = true
}
