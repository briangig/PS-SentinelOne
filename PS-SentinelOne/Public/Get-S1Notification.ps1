function Get-S1Notification {
    <#
    .SYNOPSIS
        Gets information related to policies in SentinelOne
    
    .PARAMETER SiteID
        Get policy settings by Site ID
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="SiteID")]
        [String[]]
        $SiteID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/settings/notifications"
        $Parameters = @{}
        $Parameters.Add("siteIds", $SiteID)

        $Response = Invoke-S1Query -URI $URI -Method Get -Parameters $Parameters
        Write-Output $Response.data
    }
}