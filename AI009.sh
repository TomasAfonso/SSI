#!/bin/bash
# Script de Hardening Simulado - AI009 (Plataformas em Nuvem)

# Objetivo: Exemplo de correção de configurações inseguras em ambiente cloud local (simulado)

# 1. Criar simulação de bucket exposto
mkdir -p /srv/cloud_storage/public_bucket
chmod 777 /srv/cloud_storage/public_bucket

echo "[!] Bucket criado com permissões inseguras (777)."

# 2. Corrigir permissões
chmod 750 /srv/cloud_storage/public_bucket
echo "[✔] Permissões corrigidas (750)."

# 3. Simular backup automático seguro
mkdir -p /srv/cloud_storage/backups
BACKUP_FILE="/srv/cloud_storage/backups/backup_$(date +%F).tar.gz"
tar -czf "$BACKUP_FILE" /srv/cloud_storage/public_bucket
chmod 600 "$BACKUP_FILE"
echo "[✔] Backup criado e protegido: $BACKUP_FILE"

# 4. Criptografar backup
openssl enc -aes-256-cbc -salt -in "$BACKUP_FILE" -out "$BACKUP_FILE.enc" -k "segredo123"
rm "$BACKUP_FILE"
echo "[✔] Backup criptografado com AES-256."

# 5. Simular verificação de chave exposta
echo "AWS_SECRET_ACCESS_KEY=1234567890abcdef" > app.env
if grep -q 'AWS_SECRET_ACCESS_KEY' app.env; then
  echo "[!] Chave secreta encontrada em ficheiro de ambiente. Corrigir!"
  sed -i '/AWS_SECRET_ACCESS_KEY/d' app.env
  echo "[✔] Chave removida do ficheiro app.env."
fi
