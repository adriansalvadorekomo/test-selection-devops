#!/bin/bash
# Odoo Backup Script
# Creates timestamped archive of PostgreSQL dump + filestore

# Load database credentials from .env (same directory as this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/.env" ]; then
    set -a
    . "${SCRIPT_DIR}/.env"
    set +a
fi

BACKUP_DIR=/backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"
LOG_FILE=/var/log/backup.log
STAGING=$(mktemp -d)

mkdir -p "${BACKUP_DIR}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "${LOG_FILE}"
}

cleanup() {
    rm -rf "${STAGING}"
}
trap cleanup EXIT

log "Starting backup: ${BACKUP_FILE}"

# 1. Dump the PostgreSQL database to a fixed filename (dump.sql)
docker exec odoo-db pg_dump -U "${DB_USER:-odoo}" "${DB_NAME:-odoo_db}" > "${STAGING}/dump.sql" 2>> "${LOG_FILE}"
if [ $? -eq 0 ]; then
    log "pg_dump successful"
else
    log "pg_dump failed"
    exit 1
fi

# 2. Copy the Odoo filestore
docker cp odoo-app:/var/lib/odoo/filestore "${STAGING}/filestore" 2>> "${LOG_FILE}"
if [ $? -eq 0 ]; then
    log "Filestore copied successfully"
else
    log "Filestore copy failed"
    exit 1
fi

# 3. Create the timestamped archive (contains dump.sql + filestore/)
tar -czf "${BACKUP_FILE}" -C "${STAGING}" dump.sql filestore 2>> "${LOG_FILE}"
if [ $? -eq 0 ]; then
    log "Archive created: ${BACKUP_FILE}"
else
    log "Archive creation failed"
    exit 1
fi

log "Backup completed successfully"
echo "Backup saved to: ${BACKUP_FILE}"
