output "master_public_ip" {
    description = "Récupérer l'IP publique"
  value = aws_instance.K3s_master.public_ip
}