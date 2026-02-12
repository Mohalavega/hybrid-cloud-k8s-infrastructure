resource "azurerm_network_security_group" "nsg" {
    name = "worker-nsg-k3s"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
  
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

  security_rule {
    name                       = "NetBird-WireGuard"
    priority                   = 1002  # Priorité différente de SSH (1001)
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"      # Important : UDP, pas TCP
    source_port_range          = "*"
    destination_port_range     = "51820"    # Port par défaut de NetBird
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
    network_interface_id = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
  
}

