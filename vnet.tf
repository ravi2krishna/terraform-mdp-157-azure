resource "azurerm_virtual_network" "ecomm-vnet" {
  name                = "ecomm"
  location            = azurerm_resource_group.ecomm-rg.location
  resource_group_name = azurerm_resource_group.ecomm-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "ecomm-subnet" {
  name                 = "ecomm-subnet"
  resource_group_name  = azurerm_resource_group.ecomm-rg.name
  virtual_network_name = azurerm_virtual_network.ecomm-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "ecomm-nsg" {
  name                = "ecomm-traffic"
  location            = azurerm_resource_group.ecomm-rg.location
  resource_group_name = azurerm_resource_group.ecomm-rg.name

  security_rule {
    name                       = "ecomm-rules"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet_network_security_group_association" "ecomm-nsg-asc" {
  subnet_id                 = azurerm_subnet.ecomm-subnet.id
  network_security_group_id = azurerm_network_security_group.ecomm-nsg.id
}

resource "azurerm_public_ip" "ecomm-pip" {
  name                = "ecomm"
  resource_group_name = azurerm_resource_group.ecomm-rg.name
  location            = azurerm_resource_group.ecomm-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "ecomm-nic" {
  name                = "ecomm"
  location            = azurerm_resource_group.ecomm-rg.location
  resource_group_name = azurerm_resource_group.ecomm-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ecomm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ecomm-pip.id
  }
}

resource "azurerm_linux_virtual_machine" "ecomm-vm" {
  name                = "ecomm"
  resource_group_name = azurerm_resource_group.ecomm-rg.name
  location            = azurerm_resource_group.ecomm-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.ecomm-nic.id]
  custom_data = filebase64("ecomm.sh")

  # In Gitbash run command "ssh-keygen"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}