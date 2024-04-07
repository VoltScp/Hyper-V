$Path = "C:\Hyper-V"
$SourceVHDX = "C:\Hyper-V\Source\Sysprep\source.vhdx"
$Switch1Name = "Vswitch-Lan-01"
$Switch2Name = "Vswitch-Lan-02"

$VMs = "WHV01","WHV02"

foreach ($VM in $VMs)

{
    Write-Host "Create VM $VM" -BackgroundColor Black -ForegroundColor green
    New-VM -Name $VM -Generation 2 -MemoryStartupBytes 1GB -SwitchName $Switch1Name -Path "$Path\$VM"
    Write-Host "Adjusting some networking stuff" -BackgroundColor Black -ForegroundColor green
    Rename-VMNetworkAdapter -VMName $VM -NewName "LAN-1"
    Add-VMNetworkAdapter -VMName $VM -SwitchName $Switch1Name  –Name "LAN-2"
    Add-VMNetworkAdapter -VMName $VM -SwitchName $Switch2Name –Name "ISCSI-1"
    Add-VMNetworkAdapter -VMName $VM -SwitchName $Switch2Name –Name "ISCSI-2"
    Get-VMNetworkAdapter -VMName $VM | Set-VMNetworkAdapter -DeviceNaming On
    Write-Host "Copy VHDX" -BackgroundColor Black -ForegroundColor green
    Copy-Item $SourceVHDX -Destination "$Path\$VM\" -Recurse
    Write-Host "Attach VHDX" -BackgroundColor Black -ForegroundColor green
    Add-VMHardDiskDrive -VMName $VM -ControllerType SCSI -ControllerNumber 0 -Path "$Path\$VM\source.vhdx"
    Set-VMFirmware -VMName $VM -FirstBootDevice ((Get-VMFirmware -VMName $vm).BootOrder | Where-Object Device -like *Hard*).Device
    Write-Host "Configure Virtual Machine" -BackgroundColor Black -ForegroundColor green
    Set-VM -Name $VM -DynamicMemory -MemoryMaximumBytes 3GB -MemoryMinimumBytes 512MB -MemoryStartupBytes 1GB -ProcessorCount 2
    Write-Host "Startup $VM" -BackgroundColor Black -ForegroundColor green
    Set-VMProcessor -VMName $VM -ExposeVirtualizationExtensions $true
    Start-VM -Name $VM
}




