variable "subscription_id" {
  type        = string
  description = "Suscripción de Azure. Pasar por TF_VAR_subscription_id."
  sensitive   = true
}

variable "location" {
  type    = string
  default = "mexicocentral"
}

variable "name_prefix" {
  type    = string
  default = "utvt-tf4-dev"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{3,19}$", var.name_prefix))
    error_message = "Usa de 4 a 20 caracteres minúsculos, números y guiones, iniciando con letra."
  }
}

variable "unique_suffix" {
  type        = string
  description = "Sufijo para nombres globales, por ejemplo leg427tf4."
  default     = "leg427tf4"
  validation {
    condition     = can(regex("^[a-z0-9]{4,12}$", var.unique_suffix))
    error_message = "Usa entre 4 y 12 caracteres minúsculos o números."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "Clave pública SSH del administrador de la VM. Nunca introducir una clave privada."
  validation {
    condition     = can(regex("^ssh-(rsa|ed25519) ", trimspace(var.ssh_public_key)))
    error_message = "Se requiere una clave pública SSH RSA o ED25519."
  }
}

variable "vm_size" {
  type    = string
  default = "Standard_B2ats_v2"
}

variable "entra_admin_name" {
  type        = string
  description = "UPN o nombre del administrador Entra de PostgreSQL."
}

variable "entra_admin_object_id" {
  type        = string
  description = "Object ID del administrador Entra de PostgreSQL."
}

variable "entra_admin_type" {
  type    = string
  default = "User"
  validation {
    condition     = contains(["User", "Group", "ServicePrincipal"], var.entra_admin_type)
    error_message = "Usa User, Group o ServicePrincipal."
  }
}
