-WindowStyle Hidden

$mounts = @{
    "W:" = "\\10.0.0.150\mnt\Wave"
    "M:" = "\\10.0.0.150\mnt\Diamond"
    "N:" = "\\10.0.0.150\mnt\diamond-cache"
    "R:" = "\\10.0.0.150\mnt\recording"
    "A:" = "\\10.0.0.150\mnt\appdata"
    "T:" = "\\10.0.0.150\mnt\torrents"
    "P:" = "\\10.0.0.150\mnt\sync"
    "G:" = "\\10.0.0.138\mnt\stick"
    "U:" = "\\10.0.0.138\home\comfy"
}

$logFile = Join-Path -Path $PSScriptRoot -ChildPath "mount.log"

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
}


while ($true) {
    foreach ($drive in $mounts.GetEnumerator()) {
        $driveLetter = $drive.Key
        $networkPath = $drive.Value

        Write-Log "Ensuring NFS shares mounted..."

        if (Test-Path -path $driveLetter) {
            Write-Log "$driveLetter is already mounted" -ForegroundColor Yellow
        } else {
            Write-Log "Mounting $networkPath as $driveLetter"
            net use $driveLetter $networkPath \user:anonymous "" 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Log "$networkPath successfully mounted as $driveLetter" -ForegroundColor Green
            } else {
                Write-Log "Failed to mount $networkPath as $driveLetter" -ForegroundColor Red
                Start-Sleep -Seconds 3
            }
        }
    }
        
    Start-Sleep -Seconds 30
}