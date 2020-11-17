# Azure Machine Learning Workspace with Private Link

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "${var.prefix}-ws-${random_string.postfix.result}"
  friendly_name           = var.workspace_display_name
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  container_registry_id   = azurerm_container_registry.example.id

  identity {
    type = "SystemAssigned"
  }
}

# DNS Zones

resource "azurerm_private_dns_zone" "ws_zone_api" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone" "ws_zone_notebooks" {
  name                = "privatelink.notebooks.azure.net"
  resource_group_name = azurerm_resource_group.example.name
}

# Linking of DNS zones to Virtual Network

resource "azurerm_private_dns_zone_virtual_network_link" "ws_zone_api_link" {
  name                  = "${random_string.postfix.result}_link_api"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.ws_zone_api.name
  virtual_network_id    = azurerm_virtual_network.example.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "ws_zone_notebooks_link" {
  name                  = "${random_string.postfix.result}_link_notebooks"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.ws_zone_notebooks.name
  virtual_network_id    = azurerm_virtual_network.example.id
}

# Private Endpoint configuration

resource "azurerm_private_endpoint" "ws_pe" {
  name                = "${var.prefix}-ws-pe-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "${var.prefix}-ws-psc-${random_string.postfix.result}"
    private_connection_resource_id = azurerm_machine_learning_workspace.example.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-ws"
    private_dns_zone_ids = [azurerm_private_dns_zone.ws_zone_api.id, azurerm_private_dns_zone.ws_zone_notebooks.id]
  }
}
