FROM alpine:3.19

RUN apk add --no-cache postgresql15-client bash tzdata

COPY backup.sh /usr/local/bin/backup.sh
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/start.sh

RUN mkdir -p /backups && chmod 777 /backups

CMD ["/usr/local/bin/start.sh"]