provider "azurerm" {
  features {}
}

module "network1" {
  source  = "Azure/network/azurerm"
  version = "3.2.1"
  
  resource_group_name = "terraform"
}

module "network2" {
  source  = "Azure/network/azurerm"
  version = "3.2.1"
  
  resource_group_name = "terraform"
}