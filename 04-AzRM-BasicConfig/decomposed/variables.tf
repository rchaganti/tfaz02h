variable "location" {
  description = "Location for resource group and resources within it"
  default = "eastus"
}

variable "rg_name" {
    description = "Resource group name"
    default = "tfrg"
}

variable "vnet_name" {
  description = "Virtual network name"
  default = "tfvent"
}

variable "subnet_name" {
    description = "Subnet name"
    default = "tfsubnet"
}

variable "pip_name" {
  description = "Public IP address name"
  default = "tfpip"
}

variable "nsg_name" {
  description = "NSG name"
  default = "tfnsg"
}

variable "nic_name" {
  description = "VM NIC name"
  default = "tfnic"
}

variable "vm_name" {
  description = "Linux virtual machine name"
  default = "myLinuxVM"
}

variable "admin_username" {
  description = "Admin username"
  default = "azureuser"
}

variable "vm_size" {
  description = "Azure VM size"
  default = "Standard_DS1_v2"
}