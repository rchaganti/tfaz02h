terraform {
  required_version = ">= 0.13.0, <= 0.13.5"
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