	
terraform {
  backend "azurerm" {
    resource_group_name  = "demorg"
    storage_account_name = "tfstore"
    container_name       = "terraform"
    key                  = "dev.tfstate"
  }
}
 
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}
 
data "azurerm_client_config" "current" {}
 
#Create Resource Group
resource "azurerm_resource_group" "tamops" {
  name     = "demorg"
  location = "eastus"
}
 
#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "tamops-vnet"
  address_space       = ["192.168.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.tamops.name
}
 
# Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.tamops.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "192.168.0.0/24"
}