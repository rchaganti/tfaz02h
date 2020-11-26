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
}

locals {
    prefix = terraform.workspace
}

resource "azurerm_resource_group" "demorg" {
  name     = "${local.prefix}rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}-demo-vnetwork"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  address_space       = ["10.0.0.0/16"]
}