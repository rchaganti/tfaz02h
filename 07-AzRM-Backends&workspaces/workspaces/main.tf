terraform {
  backend "azurerm" {
    resource_group_name   = "terraform"
    storage_account_name  = "tfbackendaz2020"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }

required_providers {
    azure = {
      source  = "hashicorp/azurerm"
      version = "~> 2.33.0"
    }
  }
}

provider "azure" {
  features {}
  environment = "public"
  subscription_id = "5073fd4c-3a1b-4559-8371-21e034f70820"
  client_id       = "659464c4-d349-4cd2-87fb-a7d9aedabd2b"
  client_secret   = "m4V1H.raoSJn0NdX~qg7sDqIlgkmkHMLz7"
  tenant_id       = "e8492068-d56c-42d8-8bed-f978a9a74d8e"
}

locals {
    prefix = terraform.workspace
}

resource "azurerm_resource_group" "demorg" {
  name     = "${local.prefix}rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}-demo-network"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  address_space       = ["10.0.0.0/16"]
}