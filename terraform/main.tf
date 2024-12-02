provider "azurerm" {
  features {}
  subscription_id = var.azure-id
}

resource "azurerm_resource_group" "tfvm" {
  name     = var.name_vm
  location = var.location
}

resource "azurerm_virtual_network" "firstVN" {
  name                = "firstVN-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tfvm.location
  resource_group_name = azurerm_resource_group.tfvm.name
}

resource "azurerm_subnet" "sn1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.tfvm.name
  virtual_network_name = azurerm_virtual_network.firstVN.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "firstNic" {
  name                = "firstNic"
  location            = azurerm_resource_group.tfvm.location
  resource_group_name = azurerm_resource_group.tfvm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  depends_on = [azurerm_virtual_network.firstVN]  # Dependencia explícita para asegurar que la red virtual esté lista
}

resource "azurerm_linux_virtual_machine" "vmtf" {
  name                = "vmtf-machine"
  resource_group_name = azurerm_resource_group.tfvm.name
  location            = azurerm_resource_group.tfvm.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Password1234!"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.firstNic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.tfvm.location
  resource_group_name = azurerm_resource_group.tfvm.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vm-public-ip"
  location            = azurerm_resource_group.tfvm.location
  resource_group_name = azurerm_resource_group.tfvm.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.firstNic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}