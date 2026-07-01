# Test Sélection DevOps — Stack Odoo

Stack Odoo 17 + PostgreSQL 15 + Nginx conteneurisée avec Docker Compose.

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

Odoo est accessible sur http://localhost:8069 ou http://erp.local (ajouter `127.0.0.1 erp.local` dans `/etc/hosts`).

## Sauvegarde

```bash
cd apps
./backup.sh
```

L'archive est créée dans `/backup/backup_YYYYMMDD_HHMMSS.tar.gz`.

## Restauration après crash

Voir `docs/restauration.md` pour le runbook complet.

## Arborescence

```
├── apps/
│   ├── docker-compose.yml
│   ├── .env.example
│   ├── backup.sh
│   └── nginx/
│       └── odoo.conf
├── docs/
│   ├── restauration.md
│   └── journal-ia.md
├── .gitignore
└── README.md
```
