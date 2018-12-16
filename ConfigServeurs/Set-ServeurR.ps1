
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install git vscode

Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools

new-item "C:\_Examen" -ItemType Directory
New-SmbShare -Name "DATA" -Path "C:\_Examen" -FullAccess "Everyone"