# Key Vault for Azure Machine Learning with VNET binding (no Private Link)

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
