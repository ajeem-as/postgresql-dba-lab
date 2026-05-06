#!/bin/bash
# PostgreSQL Automated Backup Script
# Author: Ajeem A S
# Purpose: Daily backup with retention and logging

DB_NAME="repl_test"
BACKUP_DIR="/var/backups/postgresql"
LOG_FILE="/var/log/postgresql/backup.log"
RETENTION_DAYS=7
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.dump"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

log "Starting backup of $DB_NAME"

pg_dump -U postgres -Fc $DB_NAME -f $BACKUP_FILE

if [ $? -eq 0 ]; then
    SIZE=$(du -sh $BACKUP_FILE | cut -f1)
    log "SUCCESS: Backup completed - $BACKUP_FILE (Size: $SIZE)"
else
    log "FAILED: Backup failed for $DB_NAME"
    exit 1
fi

DELETED=$(find $BACKUP_DIR -name "${DB_NAME}_*.dump" \
    -mtime +$RETENTION_DAYS -delete -print | wc -l)
log "Cleanup: Deleted $DELETED backups older than $RETENTION_DAYS days"
log "Backup process completed"
