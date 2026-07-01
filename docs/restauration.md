# Restauration — Runbook PRA

## Prérequis

- Docker Engine v24+
- Docker Compose v2+
- Fichier `.env` configuré à la racine de `apps/`

## Étapes de restauration

### 1. Exécuter une sauvegarde

```bash
cd apps
chmod +x backup.sh
./backup.sh
```

L'archive est créée dans `/backup/backup_YYYYMMDD_HHMMSS.tar.gz`.

### 2. Simuler un crash (suppression totale)

```bash
docker compose down -v
docker volume ls   # vérifier que les volumes sont supprimés
```

### 3. Extraire l'archive

```bash
cd /backup
tar -xzf backup_YYYYMMDD_HHMMSS.tar.gz
# L'archive contient : dump.sql + filestore/
```

### 4. Restaurer la base de données

```bash
docker compose up -d db
# Attendre que PostgreSQL soit prêt (~10 s), puis recréer la base
docker exec odoo-db createdb -U ${DB_USER} ${DB_NAME}
docker exec -i odoo-db psql -U ${DB_USER} -d ${DB_NAME} < /backup/dump.sql
```

### 5. Restaurer le filestore

```bash
docker compose up -d odoo
# Attendre que le conteneur Odoo soit prêt
docker cp /backup/filestore odoo-app:/var/lib/odoo/
```

### 6. Redémarrer la stack

```bash
docker compose up -d
```

Vérifier qu'Odoo est accessible sur http://localhost:8069 ou http://erp.local et que le module Ventes est présent.
