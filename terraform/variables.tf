#variables.tf 

variable "region" {
  description = "la région AWS ou déployer"
  type = string
  default = "eu-west-3"
}

variable "instance_type" {
  description = "Taille de l'instance EC2"
  type = string
  default = "t2.micro"
}