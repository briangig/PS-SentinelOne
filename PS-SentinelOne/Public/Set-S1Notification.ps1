function Set-S1Notification {
    <#
    .SYNOPSIS
        Gets information related to policies in SentinelOne
    
    .PARAMETER GroupID
        Get policy settings by Group ID
    
    .PARAMETER SiteID
        Get policy settings by Site ID

    .PARAMETER AccountID
        Get policy settings by Account ID
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
        $Body = @{
            "data" = $S1NotifConfig
            "filter" = @{ "siteIds" = $SiteID }
        }

        $Response = Invoke-S1Query -URI $URI -Method Put -Body ($Body | ConvertTo-Json -depth 5) -ContentType "application/json"
        Write-Output $Response.data
    }
}