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

resource "azurerm_resource_group" "tfrg" {
    name     = "tfrg"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_network" "tfvnet" {
    name                = "tfvent"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.tfrg.name

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_subnet" "tfsubnet" {
    name                 = "tfsubnet"
    resource_group_name  = azurerm_resource_group.tfrg.name
    virtual_network_name = azurerm_virtual_network.tfvnet.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "tfpip" {
    name                         = "tfpip"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.tfrg.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_security_group" "tfnsg" {
    name                = "tfnsg"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.tfrg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_interface" "tfnic" {
    name                        = "tfnic"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.tfrg.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.tfsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.tfpip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.tfnic.id
    network_security_group_id = azurerm_network_security_group.tfnsg.id
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.tfrg.name
    }

    byte_length = 8
}

resource "azurerm_storage_account" "tfstorage" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.tfrg.name
    location                    = "eastus"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" { value = tls_private_key.example_ssh.private_key_pem }

resource "azurerm_linux_virtual_machine" "tfvm" {
    name                  = "tfvm"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.tfrg.name
    network_interface_ids = [azurerm_network_interface.tfnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.tfstorage.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}