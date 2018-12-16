#--------------------------------------
# Modification du dossier par défaut des disques durs virtuels
# Modification du dossier par défaut des ordinateurs virtuels
# Création d'un commutateur virtuel de type "PRIVÉ"
# Création de trois ordinateurs virtuels
#
# Ce code doit s'exécuter sur votre serveur réel
#
# Richard Jean
#
# 30 novembre 2018
#--------------------------------------

Clear-Host

#-------------------------------------------------------------
# Modification du dossier par défaut des disques durs virtuels
#-------------------------------------------------------------
Set-VMHost  -VirtualHardDiskPath  C:\_VirDisque

#------------------------------------------------------------
# Modification du dossier par défaut des ordinateurs virtuels
#------------------------------------------------------------
Set-VMHost  -VirtualMachinePath  C:\_VirOrdi

#-------------------------------------------------
# Création du commutateur virtuel "ComPrivé"
#-------------------------------------------------
$collection = (Get-VMSwitch).Name

$nom_switch = "ComPrivé"

if ($nom_switch -notin $collection)
{
  Write-Host "CrÃ©ation du commutateur virtuel $nom_switch" -Foreground Yellow
  New-VMSwitch -Name $nom_switch `
               -SwitchType Private
}
else
{
  Write-Warning "Le commutateur virtuel $nom_switch existe déjà ."
}

#----------------------------------------------------------------------
# Le commutateur virtuel de type EXTERNE doit avoir le nom "ComPublic"
#----------------------------------------------------------------------

#-------------------------------------------------
# CrÃ©ation des trois ordinateurs virtuels
#-------------------------------------------------
New-VM -Name "Serveur1" `
       -Generation 2 `
       -VHDPath "serv1.vhdx" `
		-SwitchName "ComPublic"

New-VM -Name "Serveur2" `
       -Generation 2 `
       -VHDPath "serv2.vhdx" `
		-SwitchName "ComPrivé"

# Ajout de la deuxième carte réseau pour "Serveur2"
Add-VMNetworkAdapter -VMName "Serveur2" `
                    -SwitchName "ComPublic"

New-VM -Name "Serveur3" `
       -Generation 2 `
       -VHDPath "serv3.vhdx" `
       -SwitchName "ComPrivé"

for ($i = 1; $i -le 3; $i++)
{
 Set-VMMemory -VMName "Serveur$i" `
              -DynamicMemoryEnabled $true `
              -MaximumBytes 8192MB `
              -MinimumBytes 4096MB `
              -StartupBytes 4096MB

 Set-VMProcessor -VMName "Serveur$i" `
                 -Count 8
}
