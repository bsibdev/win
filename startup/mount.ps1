function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
}

$logFile = Join-Path -Path $PSScriptRoot -ChildPath "..\logs\mount.log"
$mountsFile = Join-Path -Path $PSScriptRoot -ChildPath "..\config\mounts.txt"

if (-not (Test-Path $mountsFile)) {
    Write-Log "Mounts file not found. Please create it at win-scripts\config\mounts.txt with drive mappings. ex: E: \\SERVER\SHARE"
}

$mounts = @{}

Get-Content -Path $mountsFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -Match "^([A-Z]:)\s+(.+)$") {
        $mounts[$matches[1]] = $matches[2]
    }
}




$failed = $false

while ($true) {
    foreach ($drive in $mounts.GetEnumerator()) {
        $driveLetter = $drive.Key
        $networkPath = $drive.Value

        Write-Log "Ensuring $driveLetter is mounted..."

        if (Test-Path -path $driveLetter) {
            Write-Log "$driveLetter is already mounted" -ForegroundColor Yellow
        } else {
            Write-Log "Mounting $networkPath as $driveLetter"
            net use $driveLetter $networkPath \user:anonymous "" 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Log "$networkPath successfully mounted as $driveLetter" -ForegroundColor Green
            } else {
                Write-Log "Failed to mount $networkPath as $driveLetter" -ForegroundColor Red
                $failed = $true
            }
        }
    }
        
    if ($failed -eq $true) {
        Write-Log "Trying again in 3 seconds..."
        Start-Sleep -Seconds 3
    } else {
        Write-Log "Rechecking mount in 30 seconds..."
        Start-Sleep -Second 30
    }
}