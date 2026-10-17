locals {
  tags = {
    project     = "terraform4"
    environment = "dev"
    owner       = "utvt"
    managed_by  = "terraform"
  }
  subnets = {
    app       = { name = "snet-app", cidr = "10.0.1.0/24" }
    db        = { name = "snet-db", cidr = "10.0.2.0/24" }
    vm        = { name = "snet-vm", cidr = "10.0.3.0/24" }
    endpoints = { name = "snet-endpoints", cidr = "10.0.4.0/24" }
    bastion   = { name = "AzureBastionSubnet", cidr = "10.0.5.0/24" }
  }
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.name_prefix}-001"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "lab" {
  name                = "vnet-${var.name_prefix}-001"
  resource_group_name = azurerm_resource_group.lab.name
  location            = azurerm_resource_group.lab.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "lab" {
  for_each                          = local.subnets
  name                              = each.value.name
  resource_group_name               = azurerm_resource_group.lab.name
  virtual_network_name              = azurerm_virtual_network.lab.name
  address_prefixes                  = [each.value.cidr]
  private_endpoint_network_policies = "Enabled"
  dynamic "delegation" {
    for_each = each.key == "app" ? [1] : []
    content {
      name = "app-service"
      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_network_security_group" "lab" {
  for_each            = local.subnets
  name                = "nsg-${var.name_prefix}-${each.key}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.tags
}

resource "azurerm_subnet_network_security_group_association" "lab" {
  for_each                  = local.subnets
  subnet_id                 = azurerm_subnet.lab[each.key].id
  network_security_group_id = azurerm_network_security_group.lab[each.key].id
}

locals {
  inbound_rules = {
    db   = { subnet = "db", port = "5432", sources = ["10.0.1.0/24", "10.0.3.0/24"] }
    blob = { subnet = "endpoints", port = "443", sources = ["10.0.1.0/24", "10.0.3.0/24"] }
    ssh  = { subnet = "vm", port = "22", sources = ["10.0.5.0/24"] }
  }
  bastion_rules = {
    https        = { direction = "Inbound", ports = ["443"], source = "Internet", destination = "*" }
    gateway      = { direction = "Inbound", ports = ["443"], source = "GatewayManager", destination = "*" }
    loadbalancer = { direction = "Inbound", ports = ["443"], source = "AzureLoadBalancer", destination = "*" }
    internal_in  = { direction = "Inbound", ports = ["8080", "5701"], source = "VirtualNetwork", destination = "VirtualNetwork" }
    ssh_out      = { direction = "Outbound", ports = ["22", "3389"], source = "*", destination = "VirtualNetwork" }
    azure_out    = { direction = "Outbound", ports = ["443"], source = "*", destination = "AzureCloud" }
    internal_out = { direction = "Outbound", ports = ["8080", "5701"], source = "VirtualNetwork", destination = "VirtualNetwork" }
    http_out     = { direction = "Outbound", ports = ["80"], source = "*", destination = "Internet" }
  }
}

resource "azurerm_network_security_rule" "services" {
  for_each                    = local.inbound_rules
  name                        = "allow-${each.key}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.port
  source_address_prefixes     = each.value.sources
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.lab[each.value.subnet].name
}

resource "azurerm_network_security_rule" "deny_other_inbound" {
  for_each                    = { for k, v in local.subnets : k => v if k != "bastion" }
  name                        = "deny-other-inbound"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.lab[each.key].name
}

resource "azurerm_network_security_rule" "bastion" {
  for_each                    = local.bastion_rules
  name                        = "allow-${each.key}"
  priority                    = 100 + index(sort(keys(local.bastion_rules)), each.key) * 10
  direction                   = each.value.direction
  access                      = "Allow"
  protocol                    = contains(["internal_in", "internal_out", "ssh_out", "http_out"], each.key) ? "*" : "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = each.value.ports
  source_address_prefix       = each.value.source
  destination_address_prefix  = each.value.destination
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.lab["bastion"].name
}

