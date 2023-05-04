param (
    [CmdletBinding()]
    [Parameter(
        Mandatory = $true
    )]
    [string]
    $Server,

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $Username,

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $Password,

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $VMHost,

    [Parameter(
        Mandatory = $true
    )]
    [string[]]
    $PhysicalNic,

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $VirtualNic,

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $DvSwitch,

    [Parameter(
        Mandatory = $true
    )]
    [string]
    $DvPortGroup

)
Set-PowerCLIConfiguration -InvalidCertificate Ignore -Confirm:$false

$SecPassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ( $Username, $SecPassword )

$VIServer = Connect-VIServer -Server $Server -Credential $Credential -NotDefault

$myVMHost = Get-VMHost -Server $VIServer $VMHost

$myVirtualNic = Get-VMHostNetworkAdapter -Server $VIServer -VMHost $myVMHost -Name  $VirtualNic
$myDvSwitch = Get-VDSwitch -Server $VIServer -Name $DvSwitch
$myDvSwitchNics = Get-VMHostNetworkAdapter -Server $VIServer -DistributedSwitch $DvSwitch

if( ($myVMHost | Get-VMHostNetworkAdapter -Name $VirtualNic).PortGroupName -eq $DvPortGroup ) { 
    Write-Host 'vmk0 Already Exists in Portgroup'
    $DvPhysicalNic = Get-VMHostNetworkAdapter -DistributedSwitch $myDvSwitch -VMHost $myVMHost -Physical
    foreach($nic in $PhysicalNic){
        if(-not ($nic.name -in $DvPhysicalNic.Name)){
            $myVMHost = Get-VMHost -Server $VIServer $VMHost
            $myDvSwitch = Get-VDSwitch -Server $VIServer -Name $DvSwitch            
            $myPhysicalNic = Get-VMHostNetworkAdapter -Server $VIServer -VMHost $myVMHost -Physical -Name $nic
            $myDvSwitch | Add-VDSwitchPhysicalNetworkAdapter -Server $VIServer -VMHostPhysicalNic $myPhysicalNic -Confirm:$false
        }
        Start-Sleep -s 10
    } 
    
}
else { 
    $firstPhysicalNic = Get-VMHostNetworkAdapter -Server $VIServer -VMHost $myVMHost -Physical -Name $PhysicalNic[0]
    $myDvSwitch | Add-VDSwitchPhysicalNetworkAdapter -Server $VIServer -VMHostPhysicalNic $firstPhysicalNic -VMHostVirtualNic $myVirtualNic -VirtualNicPortgroup $DvPortGroup -Confirm:$false
    Start-Sleep -s 60
    $DvPhysicalNic = Get-VMHostNetworkAdapter -DistributedSwitch $myDvSwitch -VMHost $myVMHost -Physical
    foreach($nic in $PhysicalNic){
        if(-not ($nic.name -in $DvPhysicalNic.Name)){
            $myVMHost = Get-VMHost -Server $VIServer $VMHost
            $myDvSwitch = Get-VDSwitch -Server $VIServer -Name $DvSwitch
            $myPhysicalNic = Get-VMHostNetworkAdapter -Server $VIServer -VMHost $myVMHost -Physical -Name $nic
            $myDvSwitch | Add-VDSwitchPhysicalNetworkAdapter -Server $VIServer -VMHostPhysicalNic $nic -Confirm:$false
        }
        Start-Sleep -s 10
    }
}

Disconnect-VIServer -Server $VIServer -Confirm:$false