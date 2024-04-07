get-vm | where state -eq running
get-vm | where state -eq running | select name
get-vm | where state -eq running | Stop-VM 
get-vm | where state -eq running | Stop-VM -force

get-vm *hv* | Start-VM
get-vm *hv* | Stop-VM -force

Enter-PSSession -VMName LSRVHV01

Checkpoint-VM "WHV01", "WHV02"
*
