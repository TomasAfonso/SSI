#!/bin/bash
# Script de Hardening para Servidores Locais (AT005)

# Atualização do sistema
echo "[+] Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instalação de ferramentas essenciais
echo "[+] Instalando auditd e sudo..."
sudo apt install auditd sudo -y

# Criação de utilizadores com RBAC básico
echo "[+] Criando grupos e utilizadores..."
sudo groupadd operadores
sudo groupadd gestores
sudo groupadd administradores

sudo useradd -m alice -G operadores
sudo useradd -m bob -G gestores
sudo useradd -m rootadmin -G administradores

# Desativar root remoto
echo "[+] Desativando login remoto do root..."
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Configurar sudo seguro para gestores e admins
echo "%gestores ALL=(ALL) /bin/systemctl restart
%administradores ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/rbac
chmod 440 /etc/sudoers.d/rbac

# Reforço de permissões de ficheiros críticos
echo "[+] Reforçando permissões de /etc/passwd e /etc/shadow..."
sudo chmod 644 /etc/passwd
sudo chmod 000 /etc/shadow

# Configuração de auditoria básica
echo "[+] Configurando regras de auditoria..."
echo "-w /etc/sudoers -p wa -k sudo_watch" | sudo tee -a /etc/audit/rules.d/audit.rules
sudo systemctl restart auditd

# Resumo
cat <<EOF

[✔] Hardening concluído:
- Atualizações aplicadas
- Grupos RBAC criados
- Root remoto desativado
- Permissões reforçadas
- Auditd ativo para sudo
EOF
