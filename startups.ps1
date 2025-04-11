Write-Host "Creating shortcuts for startup scripts..." -ForegroundColor Green

$sourceDir = Join-Path -Path $PSScriptRoot -ChildPath "startup"

$startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

if (-not (Test-Path -Path $sourceDir)) {
    Write-Host "Error: 'startup' folder not found in $PSScriptRoot." -ForegroundColor Red
    Pause
    exit 1
}   

$batScripts = Get-ChildItem -Path "$sourceDir\*.bat" -File
$powershellScripts = Get-ChildItem -Path "$sourceDir\*.ps1" -File

$wshShell = New-Object -ComObject WScript.Shell

foreach ($file in $batScripts) {
    $shortcutName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $shortcutPath = Join-Path -Path $startupDir -ChildPath "$shortcutName.lnk"

    Write-Host "Processing: $($file.Name)"

    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $file.FullName
    $shortcut.WorkingDirectory = $sourceDir
    $shortcut.Save()

    Write-Host "Shortcut for $shortcutName added to startup folder"
}

#foreach ($file in $powershellScripts) {
#
#}

Pause