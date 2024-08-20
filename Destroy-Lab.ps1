$LabVMs = get-vm -name WHV*

ForEach ($LabVM in $LabVMs)

{
    Stop-VM $LabVM -Force
    Remove-VM $LabVM -Force
    $VMName = $LabVM.name
    $VMFolder = "C:\Hyper-V\$VMName"
    Remove-Item $VMFolder -Recurse -Force
    
}