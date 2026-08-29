#!/bin/bash
# ------------------------------------------------------------
# purge-logs.sh
# Objet    : supprime les fichiers de log de plus de N jours dans un dossier
# Auteur   : emmanuelp1603@gmail.com
# Usage    : ./purge-logs.sh <dossier> [jours]
# Prerequis: droit d'ecriture sur le dossier cible, test sur Debian 13
# Retour   : 0 = OK / 1 = usage incorrect / 2 = dossier introuvable
#            3 = droits insuffisants
# ------------------------------------------------------------

#Variable definissant un chemin pour les logs genere par le scrip et commande generant un log.
FICHIER_LOG="/tmp/purge-logs.log"
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$FICHIER_LOG"
}

# Debut du log
log "=== Demarrage : dossier=$DOSSIER, seuil=$JOURS jours ==="

# Controler les arguments de l'utilisateur
if [ "$#" -lt 1 ]; then
    echo "Usage : $0 <dossier> [jours]" >&2
    echo "Exemple : $0 /tmp/faux-logs 30" >&2
    exit 1
fi

#Variables : dossier vise (obligatoire, pas de valeur par defaut), jours concernes par la purge (30 par defaut si rien n'est indique)
DOSSIER="$1"
JOURS="${2:-30}"

# Le nombre de jours doit être un entier positif.
# Si ce n'est pas le cas, la comparaison numérique échoue : on jette son
# message d'erreur et on affiche le nôtre, qui est lisible.
if ! [ "$JOURS" -ge 0 ] 2>/dev/null; then
    echo "Erreur : '$JOURS' n'est pas un nombre de jours valide" >&2
    echo "Usage : $0 <dossier> [jours]" >&2
    exit 1
fi

echo "Purge de $DOSSIER, fichiers de plus de $JOURS jours"

# Condition : si le dossier renseigne n'existe pas, la commande renvoie le message erreur. ! sert de negation a la condition suivante.
if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier $DOSSIER est introuvable" >&2
    exit 2
fi

# Condition : si on n'a pas les droits suffisants, renvoie ce code erreur
if [ ! -w "$DOSSIER" ]; then
    echo "Erreur : pas de droit d'ecriture sur $DOSSIER" >&2
    log "ERREUR : droits insuffisants sur $DOSSIER"
    exit 3
fi

# Variable indiquant le nombre de fichiers .log presents dans le dossier renseigne et datant de plus de N jours.
NB=$(find "$DOSSIER" -type f -name "*.log" -mtime +"$JOURS" | wc -l)

if [ "$NB" -eq 0 ]; then
    echo "Aucun fichier de plus de $JOURS jours dans $DOSSIER, rien à faire"
else
    echo "$NB fichier(s) à supprimer :"
    find "$DOSSIER" -type f -name "*.log" -mtime +"$JOURS" -print

 # Calcul de l'espace occupé par les fichiers concernés, AVANT suppression
    TAILLE=$(find "$DOSSIER" -type f -name "*.log" -mtime +"$JOURS" -exec du -ch {} + 2>/dev/null | tail -n 1 | cut -f1)

    # SUPPRESSION VOLONTAIREMENT COMMENTE
    # On la decommentera seulement quand la liste ci-dessus sera correcte.
    find "$DOSSIER" -type f -name "*.log" -mtime +"$JOURS" -delete
fi

if [ "$NB" -eq 0 ]; then
    log "Aucun fichier a supprimer"
else
    log "$NB fichier(s) de plus de $JOURS jours supprime(s), espace libere : $TAILLE"
fi

# fin du log
log "=== Fin de la purge ==="

exit 0

# logigramme du script
# Controler les arguments de l'utilisateur : ok
# verifier le dossier de log /tmp/faux-logs : ok
# compter les logs dans le dossier : ok
# supprimer les logs depassant la variable de N jours : ok
# journaliser, edition des logs dans le dossier /tmp/purge-logs.log : ok
# sortie du dossier de log : ok
# mise en place des codes erreurs : ok
