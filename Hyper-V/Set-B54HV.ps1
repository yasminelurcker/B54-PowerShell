
<#PSScriptInfo

.DATE 28 novembre 2018

.VERSION 0.5

.AUTHOR Yasmine Kaddouri

.EXTERNALMODULEDEPENDENCIES
HyperV

#>
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools

$HyperVSettings = @{
    VirtualHardDiskPath = "C:\_VirDisque"
    VirtualMachinePath = "C:\_VirOrdi"
}
Set-VMHost @HyperVSettings

$Nic = Get-NetAdapter | ? {$_.Status -eq "Up"}

Rename-NetAdapter -Name $Nic.Name -NewName "CartePublique"

New-VMSwitch -Name "ComPublic" -SwitchType External -NetAdapterName $Nic.Name
New-VMSwitch -Name "ComPrive" -SwitchType Private

$RAM = @(4096MB, 4096MB, 8192MB) # Ram Config (Start,Min,Max)
$vm1 = New-VM -Name "Serveur1" -MemoryStartupBytes $RAM[0] -SwitchName "ComPublic"
$vm1 | set-vm -MemoryMinimumBytes $RAM[1] -MemoryStartupBytes $RAM[2]
# TODO: Écrire pour serveur 2 et 3

$vm2 = New-VM -Name "Serveur2" -MemoryStartupBytes $RAM[0] -SwitchName "ComPublic"
$vm2 | set-vm -MemoryMinimumBytes $RAM[1] -MemoryStartupBytes $RAM[2]
Add-VMNetworkAdapter -VMName $vm2.VMName -SwitchName "ComPrive"

$vm3 = New-VM -Name "Serveur3" -MemoryStartupBytes $RAM[0] -SwitchName "ComPrive"
$vm3 | set-vm -MemoryMinimumBytes $RAM[1] -MemoryStartupBytes $RAM[2]