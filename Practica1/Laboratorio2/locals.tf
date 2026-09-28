locals {
  resource_group_name  = "rg-${var.project_name}-${var.location}-${var.environment}-001"
  virtual_network_name = "vnet-${var.project_name}-${var.location}-${var.environment}-001"

  common_tags = merge(
    var.tags,
    {
      "Project"     = var.project_name
      "Environment" = var.environment
      "Location"    = var.location
    },
  )
}
