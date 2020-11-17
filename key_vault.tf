# Key Vault with VNET binding and Private Endpoint

resource "azurerm_key_vault" "example" {
  name                = "${var.prefix}-kv-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  network_acls {
    default_action = "Deny"
    ip_rules       = []
    virtual_network_subnet_ids = [azurerm_subnet.example.id]
    bypass         = "AzureServices"
  }

}

# DNS Zones

resource "azurerm_private_dns_zone" "kv_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.example.name
}

# Linking of DNS zones to Virtual Network

resource "azurerm_private_dns_zone_virtual_network_link" "kv_zone_link" {
  name                  = "${random_string.postfix.result}_link_kv"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.kv_zone.name
  virtual_network_id    = azurerm_virtual_network.example.id
}

# Private Endpoint configuration

resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${var.prefix}-kv-pe-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "${var.prefix}-kv-psc-${random_string.postfix.result}"
    private_connection_resource_id = azurerm_key_vault.example.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-kv"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv_zone.id]
  }
}