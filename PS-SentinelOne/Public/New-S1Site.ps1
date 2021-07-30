function New-S1Site {
    <#
    .SYNOPSIS
        Create a new group in SentinelOne in the specified site. Currently only supports creating a group that inherits policy settings from the Site.
    
    .PARAMETER Name
        The name of the new site to be created

    .PARAMETER SiteID
        The site where the group should be created
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $Name,

        [Parameter(Mandatory=$True)]
        [Int]
        $totalLicenses,

        [Parameter(Mandatory=$True)]
        [String]
        $AccountID,

        [Parameter(Mandatory=$True)]
        [String]
        $SKU,

        [Parameter(Mandatory=$True)]
        [String]
        $siteType
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Body = @{
            data = @{
            siteType = $siteType
            name = $Name
            policy = $S1SourcePolicy
            totalLicenses = $totalLicenses
            accountId = $AccountID
            sku = $SKU
            }
        }
        
        $URI = "/web/api/v2.1/sites"
        $Response = Invoke-S1Query -URI $URI -Method POST -Body ($Body | ConvertTo-Json -Depth 99) -ContentType "application/json"
        Write-Output $Response.data
    }
}