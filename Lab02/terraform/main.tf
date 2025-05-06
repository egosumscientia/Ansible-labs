terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "5f55b5a1-09ef-4b87-b02d-30e1a8347b3d"
}

resource "azurerm_resource_group" "ansible_lab" {
  name     = "ansible-lab-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = "ansible-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ansible_lab.location
  resource_group_name = azurerm_resource_group.ansible_lab.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.ansible_lab.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vm" {
  count               = 2
  name                = "vm-${count.index}-pip"
  location            = azurerm_resource_group.ansible_lab.location
  resource_group_name = azurerm_resource_group.ansible_lab.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  count               = 2
  name                = "vm-${count.index}-nic"
  location            = azurerm_resource_group.ansible_lab.location
  resource_group_name = azurerm_resource_group.ansible_lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = 2
  name                            = "vm-${count.index}"
  resource_group_name             = azurerm_resource_group.ansible_lab.name
  location                        = azurerm_resource_group.ansible_lab.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.main[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "vm_public_ips" {
  value = {
    for i, vm in azurerm_linux_virtual_machine.main : 
    vm.name => azurerm_public_ip.vm[i].ip_address
  }
}