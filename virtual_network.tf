# Virtual Network definition

resource "azurerm_virtual_network" "aml_vnet" {
  name                = "${var.prefix}-vnet-${random_string.postfix.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aml_rg.location
  resource_group_name = azurerm_resource_group.aml_rg.name
}

resource "azurerm_subnet" "aml_subnet" {
  name                 = "${var.prefix}-aml-subnet-${random_string.postfix.result}"
  resource_group_name  = azurerm_resource_group.aml_rg.name
  virtual_network_name = azurerm_virtual_network.aml_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "aks_subnet" {
  count                = var.deploy_aks ? 1 : 0
  name                 = "${var.prefix}-aks-subnet-${random_string.postfix.result}"
  resource_group_name  = azurerm_resource_group.aml_rg.name
  virtual_network_name = azurerm_virtual_network.aml_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
