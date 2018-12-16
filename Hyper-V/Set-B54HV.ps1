
<#PSScriptInfo

.DATE 28 novembre 2018

.VERSION 0.5

.AUTHOR Yasmine Kaddouri

.DESCRIPTION 
installer et configurer HV et créer les répertoires


.EXTERNALMODULEDEPENDENCIES
HyperV
SUR SR
#>
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools

$HyperVSettings = @{
    VirtualHardDiskPath = "C:\_VirDisque"
    VirtualMachinePath  = "C:\_VirOrdi"
}
$HyperVSettings.Values | ForEach-Object { New-Item -Path $_ -ItemType Directory }
Set-VMHost @HyperVSettings
#interface réseaux
$Nic = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}

Rename-NetAdapter -Name $Nic.Name -NewName "CartePublique"

New-VMSwitch -Name "ComPublic" -SwitchType External -NetAdapterName "CartePublique"
New-VMSwitch -Name "ComPrive" -SwitchType Private

Write-Host ""
Read-Host -Prompt "vérifier la présence et les noms des disques."

$virtualdiskname = @("serv1.vhdx", "serv2.vhdx", "serv3.vhdx")
$virtualdisks = foreach ($disk in $virtualdiskname) {
    Get-VHD -Path "$($HyperVSettings['VirtualHardDiskPath'])\$disk"
}
#region Page 7, point 3
$RAM = @(4096MB, 4096MB, 8192MB) # Ram Config (Start,Min,Max)
$vm1 = New-VM -Name "Serveur1" -MemoryStartupBytes $RAM[0] -SwitchName "ComPublic" -VHDPath $virtualdisks[0].Path -Generation 2
$vm1 | set-vm -DynamicMemory -MemoryMinimumBytes $RAM[1] -MemoryMaximumBytes $RAM[2]
$vm1 | Set-VMProcessor -Count 8
# TODO: Écrire pour serveur 2 et 3

$vm2 = New-VM -Name "Serveur2" -MemoryStartupBytes $RAM[0] -SwitchName "ComPublic" -VHDPath $virtualdisks[1].Path -Generation 2
$vm2 | set-vm -DynamicMemory -MemoryMinimumBytes $RAM[1] -MemoryMaximumBytes $RAM[2]
Add-VMNetworkAdapter -VMName $vm2.VMName -SwitchName "ComPrive"
$vm2 | Set-VMProcessor -Count 8

$vm3 = New-VM -Name "Serveur3" -MemoryStartupBytes $RAM[0] -SwitchName "ComPrive" -VHDPath $virtualdisks[2].Path -Generation 2
$vm3 | set-vm -DynamicMemory -MemoryMinimumBytes $RAM[1] -MemoryMaximumBytes $RAM[2]
$vm3 | Set-VMProcessor -Count 8

#endregion