output "application_name" {
  value = local.application_name
}

output "unique" {
  value = local.unique
}

#variable
variable "enable_monitoring" {
    description = "Habilitar monitoreo"
    type        = bool
    default     = false
}

variable "regions" {
    description = "Lista de regiones"
    type        = list(string)
    default     = ["us-east-1", "us-west-2"]
}

variable "environment_tags" {
    description = "Ambiente de despliegue (dev, prod, etc.)"
    type        = map(string)
    default     = {
        dev  = "Development"
        prod = "Production"
    }
}

variable "aplication_config" {
    description = "Configuración de la aplicación"
    type        = object({
        name        = string
        version     = string
        description = string
    })
    default     = {
        name        = "MyApp"
        version     = "1.0.0"
        dependencies = ["lib1", "lib2"]
        description = "Aplicación de ejemplo"
    }
}


variable "allowed_networks" {
    description = "Redes permitidas"
    type        = set(string)
    default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}
