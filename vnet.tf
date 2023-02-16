resource "azurerm_virtual_network" "ecomm-vnet" {
  name                = "ecomm"
  location            = azurerm_resource_group.ecomm-rg.location
  resource_group_name = azurerm_resource_group.ecomm-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "dev"
  }
}