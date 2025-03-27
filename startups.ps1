Write-Host "Creating shortcuts for startup scripts..." -ForegroundColor Green

$sourceDir = Join-Path -Path $PSScriptRoot -ChildPath "startup"

$startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

if (-not (Test-Path -Path $sourceDir)) {
    Write-Host "Error: 'startup' folder not found in $PSScriptRoot." -ForegroundColor Red
    Pause
    exit 1
}   

$batFiles = Get-ChildItem -Path "$sourceDir\*.*" -File

$wshShell = New-Object -ComObject WScript.Shell

foreach ($file in $batFiles) {
    $shortcutName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $shortcutPath = Join-Path -Path $startupDir -ChildPath "$shortcutName.lnk"

    Write-Host "Processing: $($file.Name)"

    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $file.FullName
    $shortcut.WorkingDirectory = $sourceDir
    $shortcut.Save()

    Write-Host "Shortcut for $shortcutName added to startup folder"
}

Pause