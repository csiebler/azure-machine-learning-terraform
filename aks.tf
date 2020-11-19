# Azure Kubernetes Service

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-aks-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  
  identity {
    type = "SystemAssigned"
  }
  
}