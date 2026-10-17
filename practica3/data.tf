resource "azurerm_postgresql_flexible_server" "lab" {
  name                          = "psql-${var.name_prefix}-${var.unique_suffix}"
  resource_group_name           = azurerm_resource_group.lab.name
  location                      = azurerm_resource_group.lab.location
  version                       = "16"
  sku_name                      = "B_Standard_B1ms"
  storage_mb                    = 32768
  backup_retention_days         = 7
  public_network_access_enabled = false
  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = false
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }
  tags = local.tags
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "admin" {
  server_name         = azurerm_postgresql_flexible_server.lab.name
  resource_group_name = azurerm_resource_group.lab.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = var.entra_admin_object_id
  principal_name      = var.entra_admin_name
  principal_type      = var.entra_admin_type
}

resource "azurerm_postgresql_flexible_server_database" "lab" {
  name      = "integradora"
  server_id = azurerm_postgresql_flexible_server.lab.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_storage_account" "lab" {
  name                            = "sttf4${var.unique_suffix}"
  resource_group_name             = azurerm_resource_group.lab.name
  location                        = azurerm_resource_group.lab.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  tags                            = local.tags
}

locals {
  endpoints = {
    postgres = { zone = "privatelink.postgres.database.azure.com", subnet = "db", ip = "10.0.2.4", group = "postgresqlServer", resource_id = azurerm_postgresql_flexible_server.lab.id }
    blob     = { zone = "privatelink.blob.core.windows.net", subnet = "endpoints", ip = "10.0.4.4", group = "blob", resource_id = azurerm_storage_account.lab.id }
  }
}

resource "azurerm_private_dns_zone" "lab" {
  for_each            = local.endpoints
  name                = each.value.zone
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "lab" {
  for_each             = local.endpoints
  name                 = "link-${each.key}"
  private_dns_zone_id  = azurerm_private_dns_zone.lab[each.key].id
  virtual_network_id   = azurerm_virtual_network.lab.id
  registration_enabled = false
  tags                 = local.tags
}

resource "azurerm_private_endpoint" "lab" {
  for_each            = local.endpoints
  name                = "pep-${var.name_prefix}-${each.key}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  subnet_id           = azurerm_subnet.lab[each.value.subnet].id
  private_service_connection {
    name                           = "psc-${each.key}"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = [each.value.group]
    is_manual_connection           = false
  }
  ip_configuration {
    name               = "ip-${each.key}"
    private_ip_address = each.value.ip
    subresource_name   = each.value.group
    member_name        = each.value.group
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.lab[each.key].id]
  }
  tags       = local.tags
  depends_on = [azurerm_subnet_network_security_group_association.lab, azurerm_network_security_rule.services]
}
