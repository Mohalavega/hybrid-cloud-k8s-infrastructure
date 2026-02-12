Cluster K3s Hybride Multi-Cloud (AWS & Azure) via NetBird ZTNA

Ce projet permet de déployer un cluster Kubernetes (K3s) distribué entre AWS (Master) et Azure (Worker). La connectivité est assurée par un réseau overlay ZTNA (Zero Trust Network Access) via NetBird, garantissant une communication sécurisée et transparente entre les fournisseurs sans exposition publique des services internes.
🏗️ Architecture du Projet

    Master Node (AWS) : Instance t3.small (2 vCPUs, 2 Go RAM). Le passage à 2 Go de RAM est indispensable pour supporter simultanément le plan de contrôle K3s et l'agent ZTNA sans latence.

    Worker Node (Azure) : Instance Ubuntu standard rejoignant le cluster via le réseau Mesh.

    Réseau Overlay (ZTNA) : Utilisation de NetBird (basé sur WireGuard). Contrairement à un VPN classique, NetBird crée un maillage (Mesh) direct entre les nœuds basé sur l'identité.

⚙️ Configuration Réseau Critique

    MTU (Maximum Transmission Unit) : Fixé impérativement à 1280 sur l'interface wt0. Cela permet d'éviter la fragmentation des paquets lors du "Handshake TLS" de Kubernetes à l'intérieur du tunnel chiffré.

    Ports : Le port TCP 6443 doit être ouvert sur le Security Group AWS pour autoriser les flux de l'API Kubernetes provenant de l'interface ZTNA.

🚀 Guide de Déploiement
1. Infrastructure (Terraform)

Initialisez et créez les ressources cloud :
Bash

terraform init
terraform apply -auto-approve

Note : L'option disable_api_termination a été retirée pour faciliter les cycles de tests (Destroy/Apply).

2. Configuration du Réseau Mesh (Ansible)

Mettez à jour le fichier inventaire.ini avec les nouvelles adresses IP, puis installez NetBird :
Bash

ansible-playbook -i inventaire.ini netbird.yml

Cette étape configure automatiquement le MTU à 1280 pour stabiliser les échanges.
3. Installation de Kubernetes

Déployez le plan de contrôle, puis joignez le worker :
Bash

# Installation du Master AWS
ansible-playbook -i inventaire.ini k3s_master.yml

# Installation du Worker Azure
ansible-playbook -i inventaire.ini deploy_worker.yml

🛠️ Dépannage (Troubleshooting)

    Timeout / Context Deadline Exceeded : Souvent lié à une saturation des ressources sur le Master. Vérifiez que l'instance est bien une t3.small (1 Go de RAM est insuffisant).

    Blocage Handshake TLS : Vérifiez le MTU de l'interface NetBird : ip link show wt0. S'il est à 1500, forcez-le à 1280 : sudo ip link set dev wt0 mtu 1280.

    Logs K3s : Pour diagnostiquer la connexion sur le worker : sudo journalctl -u k3s-agent -f.

📋 Vérification du Cluster

Depuis le Master AWS, lancez la commande suivante :
Bash

sudo kubectl get nodes -o wide

Le Master et le Worker doivent apparaître avec le statut Ready et leurs adresses IP NetBird respectives.