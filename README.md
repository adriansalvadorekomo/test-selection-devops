# Test Sélection DevOps — Stack Odoo

Stack Odoo 17 + PostgreSQL 15 + Nginx conteneurisée avec Docker Compose.

## Informations du candidat

| Champ | Valeur |
|---|---|
| Nom & Prénom | Adrian Salvador Ekomo Mesi Obono |
| École / Université | ESPRIT |
| Évaluateur | ______________________________ |
| Date du test | 01/07/2026 |
| Heure de début | 07:00 |

## Prérequis

- Docker Engine v24+
- Docker Compose v2+
- Git v2+
- 4 Go RAM libre

## Démarrage en 5 commandes

```bash
git clone <repo-url> test-selection-devops
cd test-selection-devops/apps
cp .env.example .env     # éditer les mots de passe si nécessaire
docker compose up -d
```

### Initialisation de la base (premier démarrage)

La base `${DB_NAME}` est créée vide par PostgreSQL : il faut l'initialiser avec
Odoo et installer le module Ventes (avec données de démonstration) :

```bash
docker compose stop odoo
docker compose run --rm odoo odoo -i base,sale_management -d odoo_db --stop-after-init
docker compose start odoo
```

> Alternative : laisser la base vide et la créer via l'assistant web
> `http://localhost:8069/web/database/manager`.

Odoo est ensuite accessible sur http://localhost:8069 ou http://erp.local
(ajouter `127.0.0.1 erp.local` dans `/etc/hosts`).

## Sauvegarde

```bash
cd apps
./backup.sh
```

L'archive est créée dans `/backup/backup_YYYYMMDD_HHMMSS.tar.gz`.
Le chemin de sortie et le log sont surchargeables : `BACKUP_DIR` et `LOG_FILE`.

### Automatisation (backup nocturne à 02h00)

**Via cron** (production, en root car `/backup` et `/var/log` requièrent les droits root) :

```bash
sudo crontab apps/backup.cron   # entrée : 0 2 * * * .../backup.sh
```

**Via systemd** (systèmes sans cron) — unités versionnées dans `apps/systemd/` :

```bash
cp apps/systemd/odoo-backup.* ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now odoo-backup.timer
systemctl --user list-timers odoo-backup.timer   # vérifier la prochaine exécution
```

## Restauration après crash

Voir `docs/restauration.md` pour le runbook complet.

## Arborescence

```
├── apps/
│   ├── docker-compose.yml
│   ├── .env.example
│   ├── backup.sh
│   ├── backup.cron
│   ├── nginx/
│   │   └── odoo.conf
│   └── systemd/
│       ├── odoo-backup.service
│       └── odoo-backup.timer
├── docs/
│   ├── restauration.md
│   └── journal-ia.md
├── .gitignore
└── README.md
```
