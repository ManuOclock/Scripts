# ------------------------------------------------------------
# info_systeme.ps1
# Objet    : Fait un rapide état des lieux du système : 
# Objet    : Ordinateur & utilisateur, OS, CPU, RAM & Stockage
# Auteur   : emmanuelp1603@gmail.com
# Usage    : ./info_systeme.ps1 [C:/Scripts/PowerShell/info_systeme.ps1]
# Droits requis : - Droit de lecture (NTFS) sur le fichier du script
#                 - Politique d'execution PowerShell autorisant les scripts locaux (ex : RemoteSigned ou moins restrictif)
#                 - Aucun droit administrateur necessaire : les requetes Get-CimInstance utilisees sont en lecture
# Testé    : testé sur Windows 10, testé dans PowerShell ISE
# Retour   : code retour a renseigner
# ------------------------------------------------------------

# La plupart des blocs suivent le même schéma : une cmdlet Get-CimInstance récupère un objet
# et le stocke dans une variable. Les differents champs sont ensuite obtenus
# en accédant directement aux propriétés de cet objet (ex : $cs.Name, $cs.UserName).
# Il est possible d'utiliser Select-Object pour filtrer certaines propriétés
# directement dans la cmdlet 
# (ex : Get-CimInstance Win32_ComputerSystem | Select-Object Name, UserName),
# mais cette methode impose un affichage automatique (tableau/liste) moins facile
# à mettre en forme que l'acces direct aux propriétés via une variable.


Write-Host ""
Write-Host "=== Debut de l'inventaire du systeme ===" -ForegroundColor Cyan
Write-Host ""

# Partie identité de l'état des lieux : Quel ordinateur et quel utilisateur utilise le script
Write-Host "--- Ordinateur et utilisateur ---" -ForegroundColor Yellow
$cs = Get-CimInstance Win32_ComputerSystem
Write-Host "Nom de l'ordinateur : $($cs.Name)"
Write-Host "Utilisateur         : $($cs.UserName)"
Write-Host ""

#Partie horodatage de l'état des lieux : Date & heure au moment de l'exécution du script
Write-Host "--- Date et heure ---" -ForegroundColor Yellow
Write-Host "$(Get-Date)"
Write-Host ""

#Partie OS de l'état des lieux : Nom, version et architecture.
Write-Host "--- Systeme d'exploitation ---" -ForegroundColor Green
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "Nom          : $($os.Caption)"
Write-Host "Version      : $($os.Version)"
Write-Host "Architecture : $($os.OSArchitecture)"
Write-Host ""

# Partie Processeur CPU de l'état des lieux : on veut le modèle de processeur
# Et le nombre de coeurs
Write-Host "--- Processeur ---" -ForegroundColor DarkYellow
$cpu = Get-CimInstance Win32_Processor
Write-Host "Modèle            : $($cpu.Name)"
Write-Host "Nombre de coeurs  : $($cpu.NumberOfCores)"
Write-Host ""

# Partie Mémoire RAM de l'état des lieux : on veut le total en GO de RAM
# Le fabricant et le nombre de barrettes de RAM utilisées
Write-Host "--- Memoire RAM ---" -ForegroundColor DarkGreen
$ram = Get-CimInstance Win32_PhysicalMemory
$totalram = Get-CimInstance Win32_ComputerSystem
Write-Host "RAM en GO         : $([math]::Round($totalram.TotalPhysicalMemory/1GB,2))"
Write-Host "Fabricant         : $($ram.Manufacturer)"
Write-Host "Port              : $($ram.DeviceLocator)"
Write-Host ""

# Partie stockage de l'état des lieux : on veut l'espace de stockage utilisé et l'espace libre
# En valeur brute et en pourcentage pour chacun des deux disques
Write-Host "--- Stockage ---" -ForegroundColor Magenta
# On récupère chaque disque séparément grâce à un filtre sur la lettre
$diskC = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='D:'"

# Calculs pour le disque C
$cTailleGo = [math]::Round($diskC.Size/1GB,2)
$cLibreGo = [math]::Round($diskC.FreeSpace/1GB,2)
$cOccupeGo = [math]::Round($cTailleGo - $cLibreGo,2)
$cOccupePct = [math]::Round(($cOccupeGo / $cTailleGo) * 100,0)
$cLibrePct = [math]::Round(($cLibreGo / $cTailleGo) * 100,0)

# Calculs pour le disque D
$dTailleGo = [math]::Round($diskD.Size/1GB,2)
$dLibreGo = [math]::Round($diskD.FreeSpace/1GB,2)
$dOccupeGo = [math]::Round($dTailleGo - $dLibreGo,2)
$dOccupePct = [math]::Round(($dOccupeGo / $dTailleGo) * 100,0)
$dLibrePct = [math]::Round(($dLibreGo / $dTailleGo) * 100,0)

# Mise en forme des données obtenues.
$ssd = Get-CimInstance Win32_LogicalDisk
Write-Host "C: Espace occupé  : $cOccupeGo Go ($cOccupePct%)"
Write-Host "C: Espace libre   : $cLibreGo Go ($cLibrePct%)"
Write-Host "D: Espace occupé  : $dOccupeGo Go ($dOccupePct%)"
Write-Host "D: Espace libre   : $dLibreGo Go ($dLibrePct%)"
Write-Host ""
Write-Host ""

Write-Host ""
Read-Host "Appuyez sur Entree pour quitter"