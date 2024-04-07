New-VMSwitch -Name SwitchSet -NetAdapterName "Lan 1","Lan 2" -EnableEmbeddedTeaming $true -AllowManagementOS $false 

Get-VMSwitch
Get-VMSwitch |  fl
Get-VMSwitchTeam -SwitchName $Vswitch | Format-List

Set-VMSwitchTeam -Name SwitchSet -LoadBalancingAlgorithm Dynamic

Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Management
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Heartbeat
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name LiveMigration
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Storage-1
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Storage-2

Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName Management -Access -VlanId 10
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName Storage-1 -Access -VlanId 11
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName Storage-2 -Access -VlanId 11

Enable-NetAdapterRdma -Name "vEthernet (Storage-1)","vEthernet (Storage-2)"
Get-NetAdapterRdma |? Enabled -like $true

Set-VMNetworkAdapterTeamMapping -VMNetworkAdapterName Storage-1 -PhysicalNetAdapterName "Lan 1" -SwitchName SwitchSet -ManagementOS
Set-VMNetworkAdapterTeamMapping -VMNetworkAdapterName Storage-2 -PhysicalNetAdapterName "Lan 2" -SwitchName SwitchSet -ManagementOS

Get-NetAdapter
New-NetIPAddress -InterfaceIndex 17 -IPAddress 10.0.10.24 -PrefixLength 24 -Type Unicast -DefaultGateway 10.0.10.1
Set-DnsClientServerAddress -InterfaceIndex 17 -ServerAddresses 10.0.10.10,10.0.10.12
New-NetIPAddress -InterfaceIndex 29 -IPAddress 10.0.10.40 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceIndex 33 -IPAddress 10.0.10.41 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceIndex 21 -IPAddress 10.0.10.60 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceIndex 25 -IPAddress 10.0.10.70 -PrefixLength 24 -Type Unicast

Get-NetAdapter
New-NetIPAddress -InterfaceAlias "vEthernet (Management)" -IPAddress 10.0.10.24 -PrefixLength 24 -Type Unicast -DefaultGateway 10.0.10.1
Set-DnsClientServerAddress -InterfaceAlias "vEthernet (Management)" -ServerAddresses 10.0.10.10,10.0.10.12
New-NetIPAddress -InterfaceAlias "vEthernet (Storage-1)" -IPAddress 10.0.10.40 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceAlias "vEthernet (Storage-2)" -IPAddress 10.0.10.41 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceAlias "vEthernet (Heartbeat)" -IPAddress 10.0.10.60 -PrefixLength 24 -Type Unicast
New-NetIPAddress -InterfaceAlias "vEthernet (LiveMigration)" -IPAddress 10.0.10.70 -PrefixLength 24 -Type Unicast