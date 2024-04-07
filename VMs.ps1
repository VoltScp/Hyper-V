$Path = "V:\"
$SwitchName = "InternalNat"

$VMs = "WSInsiders","W11Insiders"

foreach ($VM in $VMs)

{
    New-VM -Name $VM -Generation 2 -MemoryStartupBytes 4GB -SwitchName $SwitchName -Path "$Path\$VM"
    New-VHD -Path $Path\$VM\$VM.vhdx -SizeBytes 60GB -Dynamic
    Add-VMHardDiskDrive -VMName $VM -Path $Path\$VM\$VM.vhdx
    Add-VMDvdDrive -VMName $vm -Path "V:\ISO\Windows_InsiderPreview_Server_vNext_en-us_26085.iso"
    Set-VM -Name $VM -DynamicMemory -MemoryMaximumBytes 8GB -MemoryMinimumBytes 512MB -MemoryStartupBytes 4GB -ProcessorCount 2
    Set-VMFirmware -VMName $vm -FirstBootDevice ((Get-VMFirmware -VMName $vm).BootOrder | Where-Object Device -like *DvD*).Device
    Start-VM -Name $VM
}

