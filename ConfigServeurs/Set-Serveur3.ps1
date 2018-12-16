#region Général
Rename-Computer "538S3V16"
net use R: \\10.57.54.100\DATA

$nicV1 = Get-NetAdapter
Rename-NetAdapter -Name $nicV1.ifAlias -NewName "CartePrive"
New-NetIPAddress -IPAddress "172.16.54.101" -InterfaceIndex $nicV1.ifIndex -PrefixLength 16 -DefaultGateway "172.16.54.104"
Set-DnsClientServerAddress -InterfaceIndex $nicV1.ifIndex -ServerAddresses "172.16.54.104"
New-NetFirewallRule -Name Allow_Ping -DisplayName “Allow Ping”  -Description “Packet Internet Groper ICMPv4” -Protocol ICMPv4 -IcmpType 8 -Enabled True -Profile Any -Action Allow

#endregion

#section DHCP
Install-WindowsFeature -Name DHCP -IncludeAllSubFeature -IncludeManagementTools