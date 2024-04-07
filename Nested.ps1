Install-WindowsFeature -Name DHCP,Hyper-V  –IncludeManagementTools

Enable-WindowsOptionalFeature –Online -FeatureName Microsoft-Hyper-V –All -NoRestart

$switchName = "InternalNAT"
New-VMSwitch -Name $switchName -SwitchType Internal
New-NetNat –Name $switchName –InternalIPInterfaceAddressPrefix “10.0.10.0/24”
$ifIndex = (Get-NetAdapter | ? {$_.name -like "*$switchName)"}).ifIndex
New-NetIPAddress -IPAddress 10.0.10.1 -InterfaceIndex $ifIndex -PrefixLength 24


Add-DhcpServerV4Scope -Name "DHCP-$switchName" -StartRange 10.0.10.10 -EndRange 10.0.10.50 -SubnetMask 255.255.255.0
Set-DhcpServerV4OptionValue -Router 10.0.10.1 -DnsServer 168.63.129.16
Restart-service dhcpserver