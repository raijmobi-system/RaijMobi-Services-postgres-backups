#!/bin/bash

# Configurações (via variáveis de ambiente)
DB_HOST="${DB_HOST:-postgres-user}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-raijmobi_user_db}"
DB_USER="${DB_USER:-raijmobi_user}"
DB_PASSWORD="${DB_PASSWORD:-raijmobi_pass}"
BACKUP_DIR="${BACKUP_DIR:-/backups}"

export PGPASSWORD="$DB_PASSWORD"

MAX_RETRIES=3
RETRY_DELAY=10   # segundos

attempt=1
while [ $attempt -le $MAX_RETRIES ]; do
    echo "[$(date)] Tentativa $attempt de backup do banco ${DB_NAME}..."

    # Aguarda o banco estar disponível antes de tentar
    echo "Verificando conexão com $DB_HOST:$DB_PORT..."
    until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t 5 > /dev/null 2>&1; do
        echo "Banco não está pronto. Aguardando 5s..."
        sleep 5
    done

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"

    if pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"; then
        echo "[$(date)] Backup criado com sucesso: $BACKUP_FILE"
        echo "[$(date)] Rotina de backup concluída."
        exit 0
    else
        echo "[$(date)] ERRO ao criar backup (tentativa $attempt)."
        if [ $attempt -lt $MAX_RETRIES ]; then
            echo "Aguardando ${RETRY_DELAY}s antes da próxima tentativa..."
            sleep $RETRY_DELAY
        fi
    fi
    attempt=$((attempt + 1))
done

echo "[$(date)] Todas as tentativas de backup falharam."
exit 1