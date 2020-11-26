# Example conditional expression
variable "filename" {
  type    = string
  default = ""
}

resource "random_string" "sa-name" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "azurerm_storage_account" "trainingsa" {
  name                     = "trainingsa${random_string.sa-name.result}"
  location                 = azurerm_resource_group.demo.location
  resource_group_name      = azurerm_resource_group.demo.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "trainingco" {
  name                  = "trainingco${random_string.sa-name.result}"
  storage_account_name  = azurerm_storage_account.trainingsa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "training-file" {
  name                   = var.filename != "" ? var.filename : "trainingfile.txt"
  storage_account_name   = azurerm_storage_account.trainingsa.name
  storage_container_name = azurerm_storage_container.trainingco.name
  type                   = "Block"
  source = var.filename != "" ? var.filename : "trainingfile.txt"
}