


Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools

New-SmbShare -Name "DATA" -Path "C:\_Examen" -FullAccess "Everyone"