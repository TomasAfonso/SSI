#!/bin/bash
# Script de Configuração - AI005 (Firewall e Monitorização com Wazuh)

# Atualizar sistema
echo "[+] Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instalar UFW e configurar regras básicas
echo "[+] Instalando e configurando UFW..."
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 514/udp  # syslog remoto
sudo ufw enable

# Instalar agente Wazuh (modo rápido)
echo "[+] Instalando agente Wazuh..."
curl -sO https://packages.wazuh.com/4.x/apt/install.sh
sudo bash install.sh -a

# Configurar agente para servidor (exemplo IP 192.168.1.10)
sudo sed -i 's/<address>.*<\/address>/<address>192.168.1.10<\/address>/' /var/ossec/etc/ossec.conf

# Reiniciar agente
sudo systemctl restart wazuh-agent

# Exibir estado final
echo "[✔] Firewall ativa e Wazuh configurado para monitorização."
sudo ufw status verbose
