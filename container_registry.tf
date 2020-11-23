# Azure Container Registry (no VNET binding and/or Private Link)

resource "azurerm_container_registry" "aml_acr" {
  name                     = "${var.prefix}acr${random_string.postfix.result}"
  resource_group_name      = azurerm_resource_group.aml_rg.name
  location                 = azurerm_resource_group.aml_rg.location
  sku                      = "Standard"
  admin_enabled            = true
}