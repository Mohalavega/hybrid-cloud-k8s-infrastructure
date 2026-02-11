resource "azurerm_linux_virtual_machine" "worker" {
  name = "azure-worker-k3s"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size = var.vm_size
  admin_username = "ubuntu"

  network_interface_ids = [
    azurerm_network_interface.nic.id
    ]

    admin_ssh_key {
      username = "ubuntu"
      public_key = file("azure-key.pub")
    }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts-gen2"
    version = "latest"
  }

}