resource "azurerm_resource_group" "rg" {
  name     = "testrg"
  location = "Japan East"

  tags = {
    environment = "Terraform Azure"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "test-vnet"
  location            = "Japan East"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "test-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefix       = "10.0.10.0/24"
}

resource "azurerm_network_interface" "nic" {
  name                = "test-nic"
  location            = "Japan East"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                         = "test-ip"
  location                     = "Japan East"
  resource_group_name          = azurerm_resource_group.rg.name
    allocation_method   = "Static"
  domain_name_label            = "testdevops"
}

resource "azurerm_storage_account" "storage" {
  name                     = "ded23a7fe01e004b"
  location                 = "Japan East"
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "testvm"
  location              = "Japan East"
  resource_group_name   = azurerm_resource_group.rg.name
  vm_size               = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.nic.id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "test-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "VMtest"
    admin_username = "blake"
    admin_password = "test123*"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
}