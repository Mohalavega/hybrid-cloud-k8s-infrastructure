output "worker_public_ip" {
  description = "Récupérer l'IP du worker"
  value = azurerm_public_ip.pip.ip_address
}