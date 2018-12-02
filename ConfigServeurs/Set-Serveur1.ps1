#region Général
Rename-Computer "538S1V16"
net use R: \\538S1R16\DATA
$password = ConvertTo-SecureString -AsPlainText "AAAaaa111" -Force
$nicV1 = Get-NetAdapter
Set-DnsClientServerAddress -InterfaceIndex $nicV1.ifIndex -ServerAddresses "10.57.54.100"
#endregion
## TODO : Set-Serveur2.ps1 et Set-Serveur3.ps1, section général

#section IIS
Install-WindowsFeature -Name Web-WebServer,Web-Ftp-Server,Web-MGMT-Tools -IncludeAllSubFeature

$sitesDirectories = @("C:\_Web","C:\_Web\Public","C:\_Web\Prive","C:\_Web\Vendeurs","C:\_WebA1","C:\_WebA2","C:\_Web\ww1","C:\_Web\ww2","C:\_FTP","C:\_FTP\Public","C:\_FTP\Intranet","C:\_FTP\Personel")
$utilisateurs = @("Pierre","Jean","Guy","Adminstrator","anonymous")

foreach ($dir in $sitesDirectories) {
    New-item -ItemType Directory -Path $dir -Force
}
foreach ($user in $utilisateurs) {
    New-item -ItemType Directory -Path "$($sitesDirectories[10])\$user" -Force
    New-item -ItemType Directory -Path "$($sitesDirectories[11])\$user" -Force
}

$pierreparam = @{
    Name        = "pierre"
    FullName    = "Pierre"
    Password    = $password
    UserMayNotChangePassword = $true
}
New-LocalUser @pierreparam
$guyparam = @{
    Name        = "guy"
    FullName    = "Guy"
    Password    = $password
    UserMayNotChangePassword = $true
}
New-LocalUser @guyparam
$jeanparam = @{
    Name        = "jean"
    FullName    = "Jean"
    Password    = $password
    UserMayNotChangePassword = $true
}
New-LocalUser @jeanparam

#TODO:  à copier dans les autres serveurs
Set-LocalUser -Name Administrator -Password $password