variable "length" {
  description = "Longitud del string aleatorio"
  type        = number
  default     = 16
}

variable "application_name" {
  description = "Nombre de la aplicación"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, prod, etc.)"
  type        = string
}
