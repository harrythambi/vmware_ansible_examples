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
    [string]
    $VirtualNic,

    [Parameter()]
    [bool]
    $EnableMgmt,

    [Parameter()]
    [bool]
    $EnableVmotion,

    [Parameter()]
    [bool]
    $EnableVsan,

    [Parameter()]
    [bool]
    $EnableFt
)
Set-PowerCLIConfiguration -InvalidCertificate Ignore -Confirm:$false
$SecPassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ( $Username, $SecPassword )

$VIServer = Connect-VIServer -Server $Server -Credential $Credential -NotDefault

$myVMHost = Get-VMHost -Server $VIServer $VMHost
$myVirtualNic = Get-VMHostNetworkAdapter -Server $VIServer -VMHost $myVMHost -Name  $VirtualNic

$myVirtualNic |Set-VMHostNetworkAdapter -ManagementTrafficEnabled $EnableMgmt -VMotionEnabled $EnableVmotion -VsanTrafficEnabled $EnableVsan -FaultToleranceLoggingEnabled $EnableFt -Confirm:$false

Disconnect-VIServer -Server $VIServer -Confirm:$false