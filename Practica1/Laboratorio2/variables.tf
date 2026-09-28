variable "proyect_name" {
    description = "The Azure region to deploy resources in."
    type        = string

    validation {
        condition     = length(var.proyect_name) >= 5 && length(var.proyect_name) <= 20
        error_message = "The proyect_name variable must not be empty."
    }
}

variable "environment" {
    description = "The Azure region to deploy resources in."
    type        = string

    validation {
        condition   = contains(["dev", "test", "prod"], var.environment)
        error_message = "The environment variable must be one of 'dev', 'test', or 'prod'."
    }
}

variable "location" {
    description = "The Azure region to deploy resources in."
    type        = string

    default     = "mexico central"
}

variable "vnet_address_apace" {
    description = "The name of the resource group to create."
    type        = string

    default    = "10.0.0.0/16"

}


variable tags {
    description = "A map of tags to assign to the resource."
    type        = map(string)

    default = "terraform"
}
