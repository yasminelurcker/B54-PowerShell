#region Général
Rename-Computer "538S2V16"


$nicPub = Get-NetAdapter | Out-GridView -Title "Choisir carte publique" -PassThru
$nicPub = Rename-NetAdapter -Name $nicPub.ifAlias -NewName "CartePublique" -PassThru
New-NetIPAddress -IPAddress "10.57.54.104" -InterfaceIndex $nicPub.ifIndex -PrefixLength 16 -DefaultGateway "10.57.1.1"
Set-DnsClientServerAddress -InterfaceIndex $nicPub.ifIndex -ServerAddresses "127.0.0.1"
New-NetFirewallRule -Name Allow_Ping -DisplayName “Allow Ping”  -Description “Packet Internet Groper ICMPv4” -Protocol ICMPv4 -IcmpType 8 -Enabled True -Profile Any -Action Allow

$nicPrive = Get-NetAdapter | Where-Object { $_.ifIndex -ne $nicV1.ifIndex  }
Rename-NetAdapter -Name $nicPrive.ifAlias -NewName "cartePrive"
New-NetIPAddress -IPAddress "172.16.54.104" -InterfaceAlias $nicPrive.ifAlias -DefaultGateway "10.57.54.104" -PrefixLength 16

net use R: \\10.57.54.100\DATA
#endregion

#section DNS
Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools

#section ROUTER
Install-WindowsFeature -Name Routing -IncludeAllSubFeature -IncludeManagementTools
