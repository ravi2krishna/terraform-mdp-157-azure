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