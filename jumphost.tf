resource "azurerm_public_ip" "example" {
  name                    = "dsvm-pip"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
}

resource "azurerm_network_interface" "dev_vm_nic" {
  name                = "dev-vm-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_network_security_group" "dev_vm_nsg" {
  name                = "dsvm-vm-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "RDP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "dev_vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.dev_vm_nic.id
  network_security_group_id = azurerm_network_security_group.dev_vm_nsg.id
}

resource "azurerm_virtual_machine" "dev_vm" {
  name                  = "dsvm-jumpbox"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.dev_vm_nic.id]
  vm_size               = "Standard_DS3_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "microsoft-dsvm"
    offer     = "dsvm-win-2019"
    sku       = "server-2019"
    version   = "latest"
  }

  os_profile {
    computer_name  = "dev-vm"
    admin_username = var.jumphost_username
    admin_password = var.jumphost_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  identity {
      type = "SystemAssigned"
  }

  storage_os_disk {
    name              = "dev-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

}