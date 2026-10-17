resource "azurerm_network_interface" "worker" {
  name                = "nic-${var.name_prefix}-worker"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab["vm"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.3.4"
  }
  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "worker" {
  name                            = "vm-${var.name_prefix}-worker"
  resource_group_name             = azurerm_resource_group.lab.name
  location                        = azurerm_resource_group.lab.location
  size                            = var.vm_size
  admin_username                  = "azureadmin"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.worker.id]
  admin_ssh_key {
    username   = "azureadmin"
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  identity { type = "SystemAssigned" }
  tags       = local.tags
  depends_on = [azurerm_subnet_network_security_group_association.lab]
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.name_prefix}-bastion"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_bastion_host" "lab" {
  name                = "bas-${var.name_prefix}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  sku                 = "Basic"
  ip_configuration {
    name                 = "bastion"
    subnet_id            = azurerm_subnet.lab["bastion"].id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
  tags       = local.tags
  depends_on = [azurerm_network_security_rule.bastion, azurerm_subnet_network_security_group_association.lab]
}

resource "azurerm_service_plan" "lab" {
  name                = "asp-${var.name_prefix}"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = local.tags
}

resource "azurerm_linux_web_app" "lab" {
  name                          = "app-${var.name_prefix}-${var.unique_suffix}"
  resource_group_name           = azurerm_resource_group.lab.name
  location                      = azurerm_resource_group.lab.location
  service_plan_id               = azurerm_service_plan.lab.id
  https_only                    = true
  virtual_network_subnet_id     = azurerm_subnet.lab["app"].id
  public_network_access_enabled = true
  identity { type = "SystemAssigned" }
  site_config {
    always_on           = true
    minimum_tls_version = "1.2"
    application_stack { node_version = "22-lts" }
  }
  app_settings = {
    PGHOST                      = azurerm_postgresql_flexible_server.lab.fqdn
    PGDATABASE                  = azurerm_postgresql_flexible_server_database.lab.name
    PGUSER                      = "app_integrador"
    PGSSLMODE                   = "require"
    AZURE_STORAGE_ACCOUNT       = azurerm_storage_account.lab.name
    AZURE_STORAGE_BLOB_ENDPOINT = azurerm_storage_account.lab.primary_blob_endpoint
  }
  tags       = local.tags
  depends_on = [azurerm_subnet_network_security_group_association.lab]
}

resource "azurerm_role_assignment" "app_blob" {
  scope                = azurerm_storage_account.lab.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.lab.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "worker_blob" {
  scope                = azurerm_storage_account.lab.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_virtual_machine.worker.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}
