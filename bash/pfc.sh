#!/bin/bash
# ------------------------------------------------------------
# pfc.sh
# Objet    : liste les fichiers de log de plus de 30 jours
# Auteur   : emmanuelp1603@gmail.com
# Usage    : ./pfc.sh [chemin] [jours]
# Prérequis: lecture sur le dossier cible, testé sur Debian 13
# ------------------------------------------------------------



# Compteurs de score, initialisés à 0
score_joueur=0
score_ordi=0

# Boucle infinie : on la quittera avec un "break" quand le joueur voudra arrêter
while true; do

    echo "----------------------------"
    echo "Pierre / Feuille / Ciseaux"
    read -p "Ton choix : " choix_joueur

    # tr [:upper:] [:lower:] convertit tout en minuscules
    # pour que "Pierre", "PIERRE" ou "pierre" soient traités pareil
    choix_joueur=$(echo "$choix_joueur" | tr '[:upper:]' '[:lower:]')

    # Génère un choix aléatoire pour l'ordinateur parmi les 3 options
    # $RANDOM donne un nombre aléatoire, % 3 le ramène entre 0 et 2
    choix_alea=$((RANDOM % 3))
    case $choix_alea in
        0) choix_ordi="pierre" ;;
        1) choix_ordi="feuille" ;;
        2) choix_ordi="ciseaux" ;;
    esac

    echo "L'ordinateur a choisi : $choix_ordi"

    # Vérifie d'abord que le choix du joueur est valide
    if [ "$choix_joueur" != "pierre" ] && [ "$choix_joueur" != "feuille" ] && [ "$choix_joueur" != "ciseaux" ]; then
        echo "Choix invalide, réessaie avec pierre, feuille ou ciseaux."
        continue
    fi

    # Comparaison des choix pour déterminer le gagnant
    if [ "$choix_joueur" == "$choix_ordi" ]; then
        echo "Égalité !"
    elif { [ "$choix_joueur" == "pierre" ] && [ "$choix_ordi" == "ciseaux" ]; } || \
         { [ "$choix_joueur" == "feuille" ] && [ "$choix_ordi" == "pierre" ]; } || \
         { [ "$choix_joueur" == "ciseaux" ] && [ "$choix_ordi" == "feuille" ]; }; then
        echo "Tu gagnes cette manche !"
        score_joueur=$((score_joueur + 1))
    else
        echo "L'ordinateur gagne cette manche !"
        score_ordi=$((score_ordi + 1))
    fi

    echo "Score actuel -> Toi : $score_joueur | Ordinateur : $score_ordi"

    # Demande si le joueur veut rejouer
    read -p "Veux-tu rejouer ? (oui/non) " rejouer
    rejouer=$(echo "$rejouer" | tr '[:upper:]' '[:lower:]')

    # Si la réponse n'est pas "oui", on sort de la boucle
    if [ "$rejouer" != "oui" ]; then
        echo "Merci d'avoir joué !"
        echo "Score final -> Toi : $score_joueur | Ordinateur : $score_ordi"
        break
    fi

done