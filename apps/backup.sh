#!/bin/bash
# Odoo Backup Script
# Creates timestamped archive of PostgreSQL dump + filestore

BACKUP_DIR=/backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"
LOG_FILE=/var/log/backup.log
COMPOSE_PROJECT=test-selection-devops

mkdir -p "${BACKUP_DIR}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "${LOG_FILE}"
}

log "Starting backup: ${BACKUP_FILE}"

DUMP_FILE=$(mktemp)
docker exec odoo-db pg_dump -U "${DB_USER:-odoo}" "${DB_NAME:-odoo_db}" > "${DUMP_FILE}" 2>> "${LOG_FILE}"
if [ $? -eq 0 ]; then
    log "pg_dump successful"
else
    log "pg_dump failed"
    rm -f "${DUMP_FILE}"
    exit 1
fi

FILESTORE_TMP=$(mktemp -d)
docker cp odoo-app:/var/lib/odoo/filestore "${FILESTORE_TMP}" 2>> "${LOG_FILE}"
if [ $? -eq 0 ]; then
    log "Filestore copied successfully"
else
    log "Filestore copy failed"
    rm -f "${DUMP_FILE}"
    rm -rf "${FILESTORE_TMP}"
    exit 1
fi

tar -czf "${BACKUP_FILE}" -C "$(dirname "${DUMP_FILE}")" "$(basename "${DUMP_FILE}")" -C "${FILESTORE_TMP}" filestore 2>> "${LOG_FILE}"
if [ $? -eq 0 ]; then
    log "Archive created: ${BACKUP_FILE}"
else
    log "Archive creation failed"
    rm -f "${DUMP_FILE}"
    rm -rf "${FILESTORE_TMP}"
    exit 1
fi

rm -f "${DUMP_FILE}"
rm -rf "${FILESTORE_TMP}"

log "Backup completed successfully"
echo "Backup saved to: ${BACKUP_FILE}"
