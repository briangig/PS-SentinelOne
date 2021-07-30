function Create-S1Site {
    <#
    .SYNOPSIS
        Create a new site in SentinelOne. Currently requires specifying an existing site to use as the template for the new site's policy.
    
    .PARAMETER NewSiteName
        The name of the new site to be created

    .PARAMETER totalLicenses
        Number of licenes to be assigned to the site

    .PARAMETER SourceSiteID
        The SiteID of the Site we will copy the policy from and apply to the new site       

    .PARAMETER AccountID
        The master SentinelOne AccountID

    .PARAMETER NewSiteType
        The type of Site (paid/trial)

    .PARAMETER NewSiteType
        The SKU for this site (core, complete, control)
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [Int]
        $totalLicenses,

        [Parameter(Mandatory=$True)]
        [String]
        $SourceSiteID,

        [Parameter(Mandatory=$True)]
        [String]
        $AccountID,

        [Parameter(Mandatory=$True)]
        [String]
        $NewSiteName,

        [Parameter(Mandatory=$True)]
        [ValidateSet('Trial','Paid')]
        [String]
        $NewSiteType,

        [Parameter(Mandatory=$True)]
        [ValidateSet('Core','Complete','Control')]
        [String]
        $SKU
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational


        $URI = "/web/api/v2.0/sites/$SourceSiteID/policy"
        $PolicyResponse = Invoke-S1Query -URI $URI -Method Get
        Write-Output $PolicyResponse.data


        $Body = @{
            data = @{
            siteType = $NewSiteType
            name = $NewSiteName
            policy = $PolicyResponse.data
            totalLicenses = $totalLicenses
            accountId = $AccountID
            sku = $SKU
            }
        }
        
        $URI = "/web/api/v2.1/sites"
        $Response = Invoke-S1Query -URI $URI -Method POST -Body ($Body | ConvertTo-Json -Depth 99) -ContentType "application/json" -Erroraction SilentlyContinue
        Write-Output $Response.data

    }
}
