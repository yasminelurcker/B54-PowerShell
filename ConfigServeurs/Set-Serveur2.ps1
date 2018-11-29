#region Général
Rename-Computer "538S2V16"
net use R: \\538S1R16\DATA

$nicV1 = Get-NetAdapter
Set-DnsClientServerAddress -InterfaceIndex $nicV1.ifIndex -ServerAddresses "127.0.0.1"
#endregion

#section DNS
Install-WindowsFeature -Name DNS -IncludeAllSubFeature

#section ROUTER
Install-WindowsFeature -Name Routing -IncludeAllSubFeature
