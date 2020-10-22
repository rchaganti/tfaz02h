provider "azurerm" {
  version         = "~> 2.32.0"
  subscription_id = "5073fd4c-3a1b-4559-8371-21e034f70820"
  tenant_id       = "e8492068-d56c-42d8-8bed-f978a9a74d8e"
  
  use_msi         = true
  features {}
}

resource "azurerm_resource_group" "tfgroup" {
  name     = "tfresourcegroup"
  location = "eastus"
  tags = {
    Owner = "Ravikanth Chaganti"
  }
}