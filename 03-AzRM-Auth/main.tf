provider "azurerm" {
  version         = "~> 2.32.0"
  subscription_id = "5073fd4c-3a1b-4559-8371-21e034f70820"
  #client_id       = "c838d7d8-9b6d-44db-849c-14b63149b495"
  client_secret   = "ECp0IvOxjm7JcYnw~82.~EDIYz-ZIHc6Fj"
  tenant_id       = "e8492068-d56c-42d8-8bed-f978a9a74d8e"

  features {}
}

resource "azurerm_resource_group" "tfgroup" {
  name     = "tfresourcegroup"
  location = "eastus"
  tags = {
    Owner = "Ravikanth Chaganti"
  }
}