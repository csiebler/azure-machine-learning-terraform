resource "azurerm_resource_group" "aml_rg" {
  name     = var.resource_group
  location = var.location
}
