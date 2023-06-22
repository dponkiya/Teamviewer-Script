## Deploy TeamViewer Host MSI Package silently in Microsoft Windows via PowerShell
## This script is and example, and intended for testing/learning purposes only, not being supported by TeamViewer.
## https://community.teamviewer.com/English/discussion/comment/6379
## https://community.teamviewer.com/English/kb/articles/106041-assign-managed-devices-via-command-line-interface-cli
## https://community.teamviewer.com/English/kb/articles/39639-mass-deployment-improvements
## If this file extension is ".txt", rename it to ".ps1" and run it with Admin privileges


## --------------------------------------------------------------------------
cd C:\
## Run the silent installation of the TeamViewer Host (Custom Module), referencing the Custom Config ID:
## Please adjust the path to the TeamViewer_Host.msi package
Start-Process msiexec.exe -Wait '/I TeamViewer_Host.msi /qn CUSTOMCONFIGID=6dwxdch'


## --------------------------------------------------------------------------

## Deploy TeamViewer Conditional Access Registry keys to Windows 
## https://community.teamviewer.com/English/kb/articles/57261-get-started-conditional-access
## (Uncomment and set your Conditional Access Router(s))

## Wait for the TeamViewer Host to finish installation, get started up, and get a TeamViewer ID:
Start-Sleep -s 30

New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer' -Name 'ConditionalAccessServers' -PropertyType MultiString -Value 'CA-TOR-ANX-C009.teamviewer.com' -Force

## Restart the TeamViewer service to apply the TeamViewer dedicated Conditional Access registry key:
Restart-Service TeamViewer


## --------------------------------------------------------------------------

## Affiliate this Host to the Company Profile (Managed Groups/MDv2 Assignment) via SecureChannel/CA Router

## Wait for the TeamViewer Host to finish installation, get started up, and get a TeamViewer ID:
Start-Sleep -s 30



cd 'C:\Program Files (x86)\TeamViewer\'

$string = ".\TeamViewer.exe"
Invoke-Expression $string
Start-Sleep -s 30

if(get-process | ?{$_.path -eq "C:\Program Files\TeamViewer\TeamViewer.exe"}){
    Write-Output "TV Running"
}

$string2 = ".\TeamViewer.exe assignment --id 0001CoABChBY1vCA6DcR7bXHe1Jwq137EigIACAAAgAJAEOY2WTCptHqUkg22F-m2l1MFTSG3dE5t25v3mpUXpyuGkC8igFxvoM6xvXobw96zgtvdJfhmbzUHucGZJ3PlamvGUYoNdm1FSCfB_RVd75GZcO_6IGI3w7zV1tEU2YoHXofIAEQ__Pw0Qg= --retries=3 --timeout=120"
Invoke-Expression $string2
Write-Output "Done"

Start-Sleep -s 10

# Kill the process after installation

$processName = "TeamViewer"

$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue

if ($processes) {
    # Kill the process(es) forcefully
    $processes | ForEach-Object {
        $_.Kill()
    }
    Write-Host "Process '$processName' killed successfully."
} else {
    Write-Host "No process with the name '$processName' found."
}

# Delete the File after installation.

Remove-Item C:\TeamViewer_Host.msi
