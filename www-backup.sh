#!/bin/bash

TIMESTAMP=$(date +%Y%m%d-%H%M%S)

BACKUP_DIR="/var/backups/www/$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

if rsync -a -e "ssh -i /root/.ssh/sync_ed25519" \
ubuntu@192.168.1.34:/var/www/html/ \
"$BACKUP_DIR/"
then
    echo "$(date): Backup SUCCESS" >> /var/log/www-backup.log
else
    echo "$(date): Backup FAILED" >> /var/log/www-backup.log
fi

