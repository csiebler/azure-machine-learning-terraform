# Application Insights for Azure Machine Learning (no Private Link/VNET integration)

resource "azurerm_application_insights" "example" {
  name                = "${var.prefix}-ai-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}