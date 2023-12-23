$Path = "C:\Hyper-V"
$SourceVHDX = "C:\Hyper-V\Source\Sysprep\source.vhdx"
$SwitchName = "Vswitch-Lan-01"

$VMs = "LS2D-HV01","LS2D-HV02"
#$VMs = "LSRVHV01"

foreach ($VM in $VMs)

{
    Write-Host "Create VM $VM" -BackgroundColor Black -ForegroundColor green
    New-VM -Name $VM -Generation 2 -MemoryStartupBytes 1GB -SwitchName $SwitchName -Path "$Path\$VM"
    Write-Host "Copy VHDX" -BackgroundColor Black -ForegroundColor green
    Copy-Item $SourceVHDX -Destination "$Path\$VM\" -Recurse
    Write-Host "Attach VHDX" -BackgroundColor Black -ForegroundColor green
    Add-VMHardDiskDrive -VMName $VM -ControllerType SCSI -ControllerNumber 0 -Path "$Path\$VM\source.vhdx"
    Write-Host "Configure Virtual Machine" -BackgroundColor Black -ForegroundColor green
    Set-VM -Name $VM -DynamicMemory -MemoryMaximumBytes 3GB -MemoryMinimumBytes 512MB -MemoryStartupBytes 1GB -ProcessorCount 2
    Write-Host "Startup $VM" -BackgroundColor Black -ForegroundColor green
    #Start-VM -Name $VM

}


