# Create a resource group
resource "azurerm_resource_group" "ecomm-rg" {
  name     = "ecomm"
  location = "East US"
  tags = {
    environment = "dev"
  }
}