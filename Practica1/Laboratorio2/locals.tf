locals {
    resource_group_name = "rg-${var.proyect_name}-${var.location}-${var.environment}-001"
    virtual_network_name = "vnet-${var.proyect_name}-${var.location}-${var.environment}-001"

    common_tags = merge(
        var.tags,
        {
            "Project"     = var.proyect_name
            "Environment" = var.environment
            "Location"    = var.location
        },
    )
}
