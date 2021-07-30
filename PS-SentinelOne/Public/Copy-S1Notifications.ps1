function Copy-S1Notifications {
    <#
    .SYNOPSIS
        Copies Notification Settings from one SentinelOne Site to another
    
    .PARAMETER SourceSiteID
        The SiteID of the site we will copy the notification settings FROM

    .PARAMETER DestinationSiteID
        The SiteID of the site we will copy the notification settings TO
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $SourceSiteID,

        [Parameter(Mandatory=$True)]
        [String]
        $DestinationSiteID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        #Get Policy
        $URI = "/web/api/v2.1/settings/notifications"
        $Parameters = @{}
        $Parameters.Add("siteIds", $SourceSiteID)

        $SourceResponse = Invoke-S1Query -URI $URI -Method Get -Parameters $Parameters
        Write-Output $SourceResponse.data

        #Set Policy
        $URI = "/web/api/v2.1/settings/notifications"
        $Body = @{
            "data" = $SourceResponse.data
            "filter" = @{ "siteIds" = $DestinationSiteID }
        }

        $Response = Invoke-S1Query -URI $URI -Method Put -Body ($Body | ConvertTo-Json -depth 7) -ContentType "application/json"
        Write-Output $Response.data
    }
}