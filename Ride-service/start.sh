#!/bin/bash

BACKUP_INTERVAL_SECONDS="${BACKUP_INTERVAL_SECONDS:-86400}"  # 24 horas

echo "Agendador de backup iniciado. Intervalo: ${BACKUP_INTERVAL_SECONDS}s"

while true; do
    echo "[$(date)] Executando backup agendado..."
    /usr/local/bin/backup.sh
    echo "[$(date)] Próximo backup em ${BACKUP_INTERVAL_SECONDS}s..."
    sleep "$BACKUP_INTERVAL_SECONDS"
done