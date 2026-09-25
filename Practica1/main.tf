terraform {
    required_providers {
        random = {
            source  = "hashicorp/random"
            version = "~> 3.5.1 "
        }
    }

    required_version = ">= 1.0.0"
}

resource "random_string" "suffix" {
    length  = 16
    special = true
}
