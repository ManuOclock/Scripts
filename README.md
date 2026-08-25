#Scripts
 
 
# Scripts

Mes scripts d'administration système & d'autres projets d'entrainements, écrits pendant la saison Scripting et après.
Un dossier par langage, un script par tâche.

## Contenu

| Script | Rôle |
|---|---|
| `bash/pfc.sh` | jeu de pierre feuille ciseaux contre l'ordinateur |
| `bash/purge-logs.sh` | Liste les fichiers de log de plus de N jours |
| `powershell/inventaire.ps1` | Affiche les informations de base du système : OS, CPU, RAM et DISK |

## Utilisation

```bash
./bash/pfc.sh
./bash/purge-logs.sh /var/log 30
```

```powershell
.\powershell\inventaire.ps1
```

## Prérequis

- Bash, testé sur Debian 13
- PowerShell 5.1 ou supérieur pour les scripts `.ps1`
- Droits de lecture sur les dossiers analysés

## Avertissement

La suppression est commentée dans `purge-logs.sh`. Relisez le script avant de la réactiver.