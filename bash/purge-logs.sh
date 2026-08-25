#!/bin/bash
# ------------------------------------------------------------
# purge-logs.sh
# Objet    : liste les fichiers de log de plus de 30 jours
# Auteur   : prenom.nom@exemple.fr
# Usage    : ./purge-logs.sh [chemin] [jours]
# Prérequis: lecture sur le dossier cible, testé sur Debian 12
# ------------------------------------------------------------

CHEMIN="${1:-/var/log}"
JOURS="${2:-30}"

echo "Fichiers de plus de $JOURS jours dans $CHEMIN :"
find "$CHEMIN" -type f -name "*.log" -mtime +"$JOURS"

# La suppression est volontairement commentée tant que le script n'est pas validé
# find "$CHEMIN" -type f -name "*.log" -mtime +"$JOURS" -delete