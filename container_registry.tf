resource "azurerm_container_registry" "example" {
  name                     = "${var.prefix}acr${random_string.postfix.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  sku                      = "Standard"
  admin_enabled            = true
}