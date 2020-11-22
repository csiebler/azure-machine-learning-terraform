# Azure Kubernetes Service

resource "azurerm_kubernetes_cluster" "example" {
  count               = var.deploy_aks ? 1 : 0
  name                = "${var.prefix}-aks-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
	  vnet_subnet_id = azurerm_subnet.example2.id
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.3.10"
    service_cidr = "10.0.3.0/24"
	docker_bridge_cidr = "172.17.0.1/16"
  }  
  
  provisioner "local-exec" {
    command = "az ml computetarget attach aks -n myaks -i ${azurerm_kubernetes_cluster.example[count.index].id} -g ${var.resource_group} -w ${azurerm_machine_learning_workspace.example.name}"
  }
  
  depends_on = [azurerm_machine_learning_workspace.example]
}
