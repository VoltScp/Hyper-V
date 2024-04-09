New-VMSwitch -Name SwitchSet -NetAdapterName "Lan 1","Lan 2" -EnableEmbeddedTeaming $true -AllowManagementOS $false -MinimumBandwidthMode Weight
Set-VMSwitchTeam -Name SwitchSet -LoadBalancingAlgorithm Dynamic

Get-VMSwitch
Get-VMSwitch |  fl
Get-VMSwitch -SwitchName $Vswitch | Select-Object BandwidthReservationMode
Get-VMSwitchTeam -SwitchName $Vswitch | Format-List

Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Management
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Cluster
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name LiveMigration
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Backup
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Storage-1
Add-VMNetworkAdapter -ManagementOS -SwitchName SwitchSet -Name Storage-2

Get-VMNetworkAdapter -ManagementOS

Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName Management -Access -VlanId 10
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName Cluster -Access -VlanId 11
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName LiveMigration -Access -VlanId 12
Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName Backup -Access -VlanId 13


(Get-VMNetworkAdapter -ManagementOS -Name "Management").VlanSetting
(Get-VMNetworkAdapter -ManagementOS -Name "Cluster").VlanSetting
(Get-VMNetworkAdapter -ManagementOS -Name "LiveMigration").VlanSetting
(Get-VMNetworkAdapter -ManagementOS -Name "Backup").VlanSetting

Get-VMNetworkAdapterVlan -ManagementOS

Get-VMNetworkAdapter -ManagementOS -Name "MGMT" | Set-VMNetworkAdapter -MinimumBandwidthWeight 10
Get-VMNetworkAdapter -ManagementOS -Name "Cluster" | Set-VMNetworkAdapter -MinimumBandwidthWeight 10
Get-VMNetworkAdapter -ManagementOS -Name "LiveMigration" | Set-VMNetworkAdapter -MinimumBandwidthWeight 40
Get-VMNetworkAdapter -ManagementOS -Name "Backup" | Set-VMNetworkAdapter -MinimumBandwidthWeight 40

(Get-VMNetworkAdapter -ManagementOS -Name "MGMT").BandwidthSetting
(Get-VMNetworkAdapter -ManagementOS -Name "Cluster").BandwidthSetting
(Get-VMNetworkAdapter -ManagementOS -Name "LiveMigration").BandwidthSetting
(Get-VMNetworkAdapter -ManagementOS -Name "Backup").BandwidthSetting


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
