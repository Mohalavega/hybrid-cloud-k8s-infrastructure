resource "azurerm_resource_group" "rg" {
  name     = var.rg_nom
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name= "vnet-azure"
    address_space = ["10.1.0.0/16"]
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
    name = "internal"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.1.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
    name = "worker-public-ip"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
}

resource "azurerm_network_interface" "nic"{
    name= "worker-nic"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
      name="internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.pip.id
    }
}
