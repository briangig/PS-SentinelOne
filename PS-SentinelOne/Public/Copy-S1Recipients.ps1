function Copy-S1Recipients {
    <#
    .SYNOPSIS
        Copies Notification Settings from one SentinelOne Site to another
    
    .PARAMETER SourceSiteID
        The SiteID of the site we will copy the recipient settings FROM

    .PARAMETER DestinationSiteID
        The SiteID of the site we will copy the recipient settings TO
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
        $URI = "/web/api/v2.1/settings/recipients"
        $Parameters = @{}
        $Parameters.Add("siteIds", $SourceSiteID)

        $SourceResponse = Invoke-S1Query -URI $URI -Method Get -Parameters $Parameters
        
        #Set Policy
        $URI = "/web/api/v2.1/settings/recipients"
        $Body = @{
            "data" = @{}
            "filter" = @{ "siteIds" = $DestinationSiteID }
        }
        if ($SourceResponse.data.recipients.email) {$Body.data.Add("email", $SourceResponse.data.recipients.email)}
        if ($SourceResponse.data.recipients.name) {$Body.data.Add("name", $SourceResponse.data.recipients.name)}
        if ($SourceResponse.data.recipients.sms) {$Body.data.Add("sms", $SourceResponse.data.recipients.sms)}
        
        $Response = Invoke-S1Query -URI $URI -Method Put -Body ($Body | ConvertTo-Json -depth 4) -ContentType "application/json"
        Write-Output $Response.data

    }
}