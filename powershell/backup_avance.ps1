# ------------------------------------------------------------
# backup_avance.ps1
# Objet    : sauvegarde automatique des fichiers
# Auteur   : emmanuel.petit@oclock.school
# Usage    : ./backup_avance.ps1 [C:/Scripts/PowerShell/backup_avance.ps1]
# Droits requis : - Droit de lecture (NTFS) sur le fichier du script
#                 - Politique d'execution PowerShell autorisant les scripts locaux (ex : RemoteSigned ou moins restrictif)
#                 - Aucun droit administrateur necessaire : les requetes Get-CimInstance utilisees sont en lecture
# Testé    : testé sur Windows 10, testé dans PowerShell ISE
# Retour   : SUCCESS = Sauvegarde réussie sans soucis, FATAL = Le dossier source n'existe pas à l'emplacement indiqué, FAIL = La sauvegarde a échoué
# ------------------------------------------------------------

# Script en powershell effectuant une copie des dossiers & fichiers sauvegardés dans le dossier "source" vers un dossier "destination". 
# Le script indique le nombre et le poids des fichiers copiés et renseigne un fichier de logs dont le chemin est indiqué en fin d'exécution.
# 
#


Write-Host ""
Write-Host "=== Debut de la sauvegarde ===" -ForegroundColor Cyan
Write-Host ""

# Définition de la source : le dossier visé par le backup
$source = "C:\Scripts\"
# Variable : Est-ce que la source existe ? Permettra de gérer les erreurs liées à l'absence de source
$sourceExiste = Test-Path -Path $source

# Définition de la destination : le dossier où seront stockés les backup
$destination = "D:\Documents\Backup_Scripts"
# Variable : Est-ce que la destination existe ? Permettra de gérer les erreurs liées à l'absence de destination
$destinationExiste = Test-Path -Path $destination

# Définition du chemin du fichier de log
$cheminlog = "D:\Documents\Log_Backup_Scripts.log"
# Variable : Est-ce que le fichier de log existe ? Permettra de gérer les erreurs liées à l'absence de ce fichier
$cheminlogExiste = Test-Path -Path $cheminlog

# Deux variables pour permettre la création des dossiers de backup avec horodatage
$dateFormat = Get-Date -Format "yyyyMMdd_HH-mm"
$nomDossier = Split-Path $source -Leaf


if (-not $destinationExiste) {
    # Création de la destination si le dossier n'existe pas.
    New-Item -ItemType Directory -Path $destination -Force
}

if (-not $cheminlogExiste) {
    # Création du fichier de log si il n'existe pas.
    New-Item -ItemType File -Path $cheminlog -Force
}

# Variable : création du dossier de backup avec horodatage
$backup = New-Item -ItemType Directory -Path $destination -Name "${dateFormat}_${nomDossier}"

# Fonction permettant l'écriture des logs selon les résultats du script.
function Write-Log {
    param(
        $State,
        # Etat de la sauvegarde : succès, échec, warning pour un succès partiel
        $Message
        # Message du log : copie faite, nombre de fichiers créés
       
    )
    Add-Content -Path $cheminlog -Value "$dateFormat - $State - $Message"
        # Instructions utilisant les paramètres $State et $Message pour écrire un log
}

try {
    if (-not $sourceExiste) {
    # Si la source n'existe pas, le script lance le throw et interrompt le try pour passer directement au bloc suivant
        throw "La source n'existe pas"
    }
# Commande opérant la copie du dossier source et des sous-dossiers + fichiers vers le dossier destination
# Le catch ne s'active qu'en cas d'erreur mettant fin à la commande précédente. 
# L'objet -ErrorAction Stop considère chaque erreur comme terminante.
try {
        Copy-Item -Path $source -Destination $backup -Recurse -ErrorAction Stop
        
        # Variable permettant d'indiquer la taille de la sauvegarde ainsi que le nombre de fichiers copiés
        $data = Get-ChildItem -Path $backup -Recurse | Measure-Object -Property Length -Sum
        
        Write-Host ""
        Write-Host "Sauvegarde reussie - Dossier $backup créé" -ForegroundColor DarkGreen
        Write-Host "Nombre de fichiers copiés    : $($data.Count)"
        Write-Host "Poids total de la sauvegarde : $([math]::Round($data.Sum/1MB,2)) MB"
        Write-Host ""
        Write-Log -State "SUCCESS" -Message "Dossier $backup créé, $($data.Count) fichiers copiés. Poids total : $([math]::Round($data.Sum/1MB,2)) MB"
    }
    catch {
        Write-Host ""
        Write-Host "Echec de la sauvegarde : $($_.Exception.Message)" -ForegroundColor DarkRed
        Write-Host ""
        Write-Log -State "FAIL" -Message "$($_.Exception.Message)"
    }
}
# Ce catch ne se déclenche que si le throw est déclenché par l'absence de source.
catch {
    Write-Host ""
    Write-Host "Echec de la sauvegarde : $($_.Exception.Message)" -ForegroundColor Magenta
    Write-Host ""
    Write-Log -State "FATAL" -Message "$($_.Exception.Message)"
}


# Indique le path du fichier de log créé par la fonction Write-Log
Write-Host ""
Write-Host "Fichier de log disponible : $cheminlog"
Write-Host "=== Fin de la sauvegarde ===" -ForegroundColor Cyan
Write-Host ""


# Copie les fichiers en affichant une barre de progression

# Gère les erreurs de manière robuste