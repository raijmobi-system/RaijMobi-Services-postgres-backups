FROM alpine:3.19

RUN apk add --no-cache postgresql15-client bash tzdata

# Copia os scripts
COPY backup.sh /usr/local/bin/backup.sh
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/start.sh

# Cria diretório de backups
RUN mkdir -p /backups && chmod 777 /backups

# Script principal (loop infinito)
CMD ["/usr/local/bin/start.sh"]