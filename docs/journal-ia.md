# Journal IA — Test Sélection DevOps

## Prompt 1 : Structure Docker Compose

**Prompt utilisé :**
"Génère un docker-compose.yml avec Odoo 17, PostgreSQL 15 et Nginx. PostgreSQL isolé sur un réseau privé, volumes nommés pour la persistance, Nginx en reverse proxy sur erp.local."

**Ce que l'IA a généré :**
Un fichier docker-compose.yml complet avec 3 services, volumes nommés et réseau privé.

**Ce que j'ai modifié :**
J'ai ajusté les variables d'environnement pour utiliser le fichier .env et ajouté les dépendances entre services.

**Pourquoi :**
La séparation des secrets dans .evn est obligatoire pour la sécurité et la notation.

---

## Prompt 2 : Script de sauvegarde

**Prompt utilisé :**
"Écris un script Bash qui fait pg_dump via docker exec et archive le filestore d'Odoo avec un timestamp."

**Ce que l'IA a généré :**
Un script backup.sh avec pg_dump, copie du filestore et création d'archive tar.gz.

**Ce que j'ai modifié :**
Ajout de logging vers /var/log/backup.log et gestion des erreurs avec codes de sortie.

**Pourquoi :**
Le logging est explicitement demandé dans la grille de notation et la gestion d'erreurs est une bonne pratique.

---

## Prompt 3 : Documentation README

**Prompt utilisé :**
"Génère un README.md pour démarrer une stack Odoo en 5 commandes max, avec sections backup et restauration."

**Ce que l'IA a généré :**
Un README avec les commandes de base pour cloner, configurer et démarrer.

**Ce que j'ai modifié :**
Ajout des prérequis machine, d'une section de dépannage et des instructions pour la restauration après crash.

**Pourquoi :**
L'évaluateur doit pouvoir rejouer le projet sans aide — le README doit être autonome.

---

## Ce que j'ai appris aujourd'hui

J'ai appris à orchestrer une stack Odoo complète avec Docker Compose, à isoler les services par réseau, à automatiser les sauvegardes avec pg_dump et à rédiger un runbook de restauration clair. L'utilisation de l'IA a accéléré la rédaction du code tout en me permettant de me concentrer sur la compréhension de l'architecture.
