function Get-ExtendedLicenseInformation {
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param (
        [parameter()]
        [Microsoft.Management.Infrastructure.CimSession[]]$CimSession
    )

    $cimParam = @{ 
        ClassName = 'SoftwareLicensingProduct' 
        Filter = 'LicenseStatus <> 0 AND Name LIKE "Windows%"'
        #you could include specific properties, but it seems to pull them all in by default
        #Property = 
    }

    #runs locally if no cim session specified
    if ($CimSession) {
        $cimParam['cimsession'] = $CimSession
    }

    $product = Get-CimInstance @cimParam

    [PSCustomObject]@{
        Name                            = $product.Name
        Description                     = $product.Description
        'Activation ID'                 = $product.ID
        'Application ID'                = $product.ApplicationID
        'Extended PID'                  = $product.ProductKeyID
        'Product Key Channel'           = $product.ProductKeyChannel
        'Installation ID'               = $product.OfflineInstallationId
        'Use License URL'               = $product.UseLicenseURL
        'Validation URL'                = $product.ValidationURL
        'Partial Product Key'           = $product.PartialProductKey
        'License Status'                = [LicenseStatusCode]( $product.LicenseStatus)
        'Remaining Windows Rearm Count' = $product.RemainingAppReArmCount
        'Remaining SKU Rearm Count'     = $product.RemainingSkuReArmCount
        'Trusted Time'                  = [datetime]::MinValue, $product.TrustedTime | Sort-Object | Select-Object -Last 1            
    }
}
