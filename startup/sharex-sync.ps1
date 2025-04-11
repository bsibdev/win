$source = "$env:USERPROFILE\Pictures\Screenshots"
$destination = "\\10.0.0.150\mnt\user\sync\PC\Screenshots"
$logfile = "C:\Users\et\repos\win-scripts\logs\sharex-sync.log"
$interval = 1

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
}

while ($true) {
    Write-Log "Syncing at $(Get-Date -Format 'HH:mm:ss')..."
    & robocopy "$source" "$destination" /Z /R:5 /W:5 /MT:8 /V /NJH /NJS /LOG+:$logfile | Out-Null
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 1) {
        Write-Log "Sync Successful."
    }
    elseif ($exitCode -eq 0) {
        Write-Log "No changes detected."
    }
    else {
        Write-Log "Warning: Issues occurred. Check the log at $logfile."
    }

    Write-Log "Waiting $interval seconds before next sync..."
    Start-Sleep -Seconds $interval
}