resource "azurerm_resource_group" "example" {
  name     = "aml-terraform-demo"
  location = var.location
}
