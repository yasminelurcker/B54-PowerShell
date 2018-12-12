#region Général
Rename-Computer "538S3V16"
net use R: \\10.57.54.100\DATA

$nicV1 = Get-NetAdapter
Set-DnsClientServerAddress -InterfaceIndex $nicV1.ifIndex -ServerAddresses "172.16.54.104"
#endregion

#section DHCP
Install-WindowsFeature -Name DHCP -IncludeAllSubFeature -IncludeManagementTools