#!/bin/bash
# --------------------------------------------
# generer-faux-log.sh
# Objet : Genere 7 fichiers de log avec des dates de modifications allant de 2 jours avant a 60 jours avant.
# Auteur : emmanuelp1603@gmail.com
# Usage : ./generer-faux-log.sh
# Prerequis : droit d'ecriture sur le dossier, tester sur conteneur LXC Debian 13
# ---------------------------------------------

#creer le dossier faux-logs et, si il existe deja, ne provoque pas d'erreur mais passe a la suite du script
mkdir -p /tmp/faux-logs
cd /tmp/faux-logs || exit

touch -d "60 days ago" tres-vieux.log
touch -d "40 days ago" vieux1.log
touch -d "40 days ago" vieux2.log
touch -d "40 days ago" "rapport de mars.log"
touch -d "10 days ago" moyen.log
touch -d "2 days ago"  recent.log
touch -d "40 days ago" archive-fevrier.gz

#Permet de lister les fichiers crees par le script. Rendu visuel a la bonne execution du script.
ls -l --time-style=long-iso
