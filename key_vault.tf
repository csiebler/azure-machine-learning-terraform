# Key Vault for Azure Machine Learning (no Private Link/VNET integration)

resource "azurerm_key_vault" "example" {
  name                = "${var.prefix}-kv-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}
