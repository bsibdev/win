Start-Sleep -Seconds 3

$workSpaces = @(
    "C:\Users\et\AppData\Local\PowerToys\PowerToys.WorkspacesLauncher.exe {A0B15609-D9D1-4A68-ACD1-DFE2E8025778} 1",
    "C:\Users\et\AppData\Local\PowerToys\PowerToys.WorkspacesLauncher.exe {71FD2100-0C48-4872-943F-0C1382A12883} 1",
    "C:\Users\et\AppData\Local\PowerToys\PowerToys.WorkspacesLauncher.exe {CB5275E6-A2D6-496F-A573-5B6C7ACF5EAE} 1"
)

$i = 2

foreach ($workspace in $workSpaces) {
    Start-Sleep -Seconds 1
    Switch-Desktop -Desktop $i
    Start-Sleep -Seconds 2

    (New-Object -ComObject Shell.Application).MinimizeAll()
    $filePath = $workspace.Split()[0]
    $arguments = $workspace.Split()[1..($workspace.Split().Count -1)] -join " "

    Start-Process -FilePath $filePath -ArgumentList $arguments
    
    Start-Sleep -Seconds 15
    $i -= 1
}