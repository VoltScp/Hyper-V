$VMs = "WHV01","WHV02"

foreach ($VM in $VMs)

{

    Invoke-Command -VMName $VM -ScriptBlock { 

        $NewName = Read-Host "New Name"
        Rename-Computer $NewName
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
        #Get-WindowsFeature -Name Hyper-V
        
        }

}