#region Général
Rename-Computer "538S1V16"
net use R: \\538S1R16\DATA

$nicV1 = Get-NetAdapter
Set-DnsClientServerAddress -InterfaceIndex $nicV1.ifIndex -ServerAddresses "10.57.54.100"
#endregion
## TODO : Set-Serveur2.ps1 et Set-Serveur3.ps1, section général

#section IIS
Install-WindowsFeature -Name Web-WebServer,Web-FtpServer,Web-MGMT-Tools -IncludeAllSubFeature