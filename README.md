#Scripts
 
 
# Scripts

Mes scripts d'administration système & d'autres projets d'entrainements, écrits pendant la saison Scripting et après.
Un dossier par langage, un script par tâche.

## Contenu

| Script Bash | Rôle |
|---|---|
| `bash/pfc.sh` | jeu de pierre feuille ciseaux contre l'ordinateur |
| `bash/generer-faux-logs.sh` |  Génère de faux fichiers de logs datés entre 2 & 60 jours avant, permet de tester les scripts de purges |
| `bash/purge-logs.sh` | Liste les fichiers de log de plus de N jours |
| `bash/purge-logs2.sh` | Liste & suppression des fichiers de log de plus de N jours, édition des logs & codes erreurs |
| `bash/check-disk-space.sh` | Contrôle de l'espace disque utilisé / libre - TRAVAIL EN COURS |

| Script Powershell| Rôle |
|---|---|
| `powershell/inventaire.ps1` | Affiche les informations de base du système : OS, CPU, RAM et DISK |
| `powershell/info_systeme.ps1` | Affiche un état des lieux du système : Identité, OS, CPU, RAM, DISK |
| `powershell/backup_avance.ps1` | Copie un dossier source (avec ses sous-dossiers et fichiers) vers un dossier de destination, copie en bloc et édition de log |
| `powershell/backup_progress.ps1` | Copie un dossier source (avec ses sous-dossiers et fichiers) vers un dossier de destination, copie fichier par fichier, barre de progression et édition de log  |

## Utilisation


```bash
./bash/pfc.sh
./bash/purge-logs.sh /var/log 30
./bash/purge-logs2.sh <dossier> [jours]
./bash/purge-logs2.sh /var/log 30
```

```powershell
.\powershell\inventaire.ps1
.\powershell\info_systeme.ps1
.\powershell\backup_avance.ps1
.\powershell\backup_progress.ps1

```

## Prérequis

- Bash, testé sur Debian 13
- PowerShell 5.1 ou supérieur pour les scripts `.ps1`
- Droits de lecture sur les dossiers analysés

## Avertissement

La suppression est commentée dans `purge-logs.sh`. Relisez le script avant de la réactiver.