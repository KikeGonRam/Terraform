resource "random_string" "suffix" {
    length  = var.length
    special = true
}

locals {
    unique              = "${var.application_name}=${var.environment}-${random_string.suffix.result}"
    application_name    = var.application_name
}
