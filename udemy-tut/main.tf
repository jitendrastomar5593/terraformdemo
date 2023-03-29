# Required Terraform version
terraform {
  required_version = ">=0.13"
}

# Selecting Azure
provider "azurerm" {
  features {}
}

# Creating Resource Group
resource "azurerm_resource_group" "myrg" {
  name      = var.web-svr-rg
  location  = var.web-svr-location
}

# Creating Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                  = "${var.resource_prefix}-vnet"
  location              = var.web-svr-location
  resource_group_name   = azurerm_resource_group.myrg.name
  address_space         = [var.web-svr-address-space]
}

# Creating first subnet
resource "azurerm_subnet" "subnet1" {
  name                  = "${var.resource_prefix}-subnet1"
  resource_group_name   = azurerm_resource_group.myrg.name
  virtual_network_name  = azurerm_virtual_network.myvnet.name
  address_prefixes      = var.web-svr-address-prefix
}

# Creating Virtual Network Interface Card
resource "azurerm_network_interface" "mynic" {
  name                  = "${var.web-svr-name}-nic1"
  location              = var.web-svr-location
  resource_group_name   = azurerm_resource_group.myrg.name
  ip_configuration {
    name                            = "${var.resource_prefix}-ip"
    subnet_id                       = azurerm_subnet.subnet1.id
    private_ip_address_allocation   = "Dynamic"
  }
}

# # No Dependency
# resource "azurerm_virtual_network" "myvnet" {
#   name                  = "${var.resource_prefix}-vnet"
#   resource_group_name   = "web-rg"
#   location              = var.web-svr-location
#   address_space         = [var.web-svr-address-space]
# }

# # Implict Dependency
# resource "azurerm_virtual_network" "myvnet" {
#   name                  = "${var.resource_prefix}-vnet"
#   resource_group_name   = azurerm_resource_group.myrg.name
#   location              = var.web-svr-location
#   address_space         = [var.web-svr-address-space]
# }

# # Explict Dependency
# resource "azurerm_virtual_network" "myvnet" {
#   name                  = "${var.resource_prefix}-vnet"
#   resource_group_name   = azurerm_resource_group.myrg.name
#   location              = var.web-svr-location
#   address_space         = [var.web-svr-address-space]
#   depends_on            = [azurerm_resource_group.web-svr-rg]
# }

# Creating public IP
resource "azurerm_public_ip" "mypip" {
  name = "${var.resource_prefix}-pip-1"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  #allocation_method = "Dynamic"    # Simple way to allocate IP
  allocation_method = var.environment == "Production" ? "Static" : "Dynamic"  # this means, if ENV is prod -> set IP to static, else "dynamic"
}