get-vm | where state -eq running
get-vm | where state -eq running | select name

get-vm *hv* | Start-VM
get-vm *hv* | Stop-VM -force

