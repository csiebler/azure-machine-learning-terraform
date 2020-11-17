# Storage Account with Private Endpoint for Blob and File

resource "azurerm_storage_account" "example" {
  name                     = "${var.prefix}sa${random_string.postfix.result}"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_network_rules" "firewall_rules" {
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_name = azurerm_storage_account.example.name

  default_action             = "Deny"
  ip_rules                   = []
  virtual_network_subnet_ids = [azurerm_subnet.example.id]
  bypass                     = ["AzureServices"]
}

resource "azurerm_private_endpoint" "sa_pe_blob" {
  name                = "${var.prefix}-sa-pe-blob-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "${var.prefix}-sa-psc-blob-${random_string.postfix.result}"
    private_connection_resource_id = azurerm_storage_account.example.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "sa_pe_file" {
  name                = "${var.prefix}-sa-pe-file-${random_string.postfix.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "${var.prefix}-sa-psc-file-${random_string.postfix.result}"
    private_connection_resource_id = azurerm_storage_account.example.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }
}