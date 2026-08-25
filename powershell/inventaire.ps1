# Pas besoin de shebang en PowerShell, mais il faut enregistrer le fichier avec l'extension .ps1

Write-Host "===== INVENTAIRE SYSTEME =====" -ForegroundColor Cyan
Write-Host ""

# --- INFORMATIONS OS ---
# Get-CimInstance interroge le WMI (Windows Management Instrumentation)
# Win32_OperatingSystem contient les infos sur le système d'exploitation
$os = Get-CimInstance Win32_OperatingSystem

Write-Host "----- Systeme d'exploitation -----" -ForegroundColor Yellow
Write-Host "Nom de l'OS       : $($os.Caption)"
Write-Host "Version           : $($os.Version)"
Write-Host "Build              : $($os.BuildNumber)"
Write-Host "Architecture       : $($os.OSArchitecture)"
Write-Host ""

# --- INFORMATIONS PROCESSEUR ---
# Win32_Processor contient les infos sur le(s) CPU
$cpu = Get-CimInstance Win32_Processor

Write-Host "----- Processeur -----" -ForegroundColor Yellow
Write-Host "Nom               : $($cpu.Name)"
Write-Host "Coeurs physiques    : $($cpu.NumberOfCores)"
Write-Host "Coeurs logiques     : $($cpu.NumberOfLogicalProcessors)"
Write-Host "Vitesse (MHz)      : $($cpu.MaxClockSpeed)"
Write-Host ""

# --- INFORMATIONS RAM ---
# Win32_ComputerSystem contient entre autres la mémoire physique totale
$ram = Get-CimInstance Win32_ComputerSystem

# La valeur est en octets, on la convertit en Go et on arrondit à 2 décimales
$ramTotalGo = [math]::Round($ram.TotalPhysicalMemory / 1GB, 2)

Write-Host "----- Memoire RAM -----" -ForegroundColor Yellow
Write-Host "RAM totale         : $ramTotalGo Go"
Write-Host ""

# --- INFORMATIONS DISQUES ---
# Get-CimInstance Win32_LogicalDisk récupère les infos sur les lecteurs
# DriveType = 3 filtre pour ne garder que les disques locaux (pas les lecteurs réseau ou CD)
Write-Host "----- Disques -----" -ForegroundColor Yellow

$disques = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

# ForEach-Object permet de traiter chaque disque trouvé un par un
$disques | ForEach-Object {
    $espaceLibreGo = [math]::Round($_.FreeSpace / 1GB, 2)
    $espaceTotalGo = [math]::Round($_.Size / 1GB, 2)

    Write-Host "Lecteur $($_.DeviceID) : $espaceLibreGo Go libres / $espaceTotalGo Go au total"
}

Write-Host ""
Write-Host "===== FIN DE L'INVENTAIRE =====" -ForegroundColor Cyan