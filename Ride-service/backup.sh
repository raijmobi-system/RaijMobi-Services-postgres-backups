#!/bin/bash

# Configurações (via variáveis de ambiente)
DB_HOST="${DB_HOST:-postgres-ride}"          # antes: postgres-user
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-raijmobi_ride_db}"       # antes: raijmobi_user_db
DB_USER="${DB_USER:-raijmobi_ride}"          # antes: raijmobi_user
DB_PASSWORD="${DB_PASSWORD:-raijmobi_pass}"
BACKUP_DIR="${BACKUP_DIR:-/backups}"

export PGPASSWORD="$DB_PASSWORD"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"

echo "[$(date)] Iniciando backup completo do banco ${DB_NAME}..."
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "[$(date)] Backup criado com sucesso: $BACKUP_FILE"
else
    echo "[$(date)] ERRO ao criar backup!"
    exit 1
fi

echo "[$(date)] Rotina de backup concluída. Backups existentes não serão removidos."