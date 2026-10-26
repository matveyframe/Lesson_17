#!/bin/bash

DB_NAME="cars_db"
DB_USER="postgres"
BACKUP_DIR="/var/backups/carss"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/carss_backup_$DATE.sql.gz"

mkdir -p "$BACKUP_DIR"

pg_dump -U "$DB_USER" -h localhost "$DB_NAME" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup created at $BACKUP_FILE"
else
    echo "Backup failed!" >&2
    exit 1
fi

