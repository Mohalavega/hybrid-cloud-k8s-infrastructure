variable "azure_subscription_id" {
    description = "Numéro abo azure"
    type = string
}

variable "location" {
  description = "Localisation du serveur"
  type = string
  default = "France Central"
}

variable "rg_nom" {
  description = "Nom du groupe de ressource"
  type = string
  default = "rg-hybrid-k8s"
}

variable "vm_size" {
  description = "Type de VM"
  type = string 
  default = "Standard_B1s"
}