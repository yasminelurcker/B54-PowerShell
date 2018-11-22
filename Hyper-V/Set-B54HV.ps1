Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature

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

