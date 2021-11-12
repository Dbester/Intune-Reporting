<#
.SYNOPSIS
    Export the specified report from Intune to your local storage as a .zip
    
.DESCRIPTION
    Export the specified report from Intune to your local storage as a .zip
    Required to create a App Registration with the following permissions to read the data: https://docs.microsoft.com/en-us/graph/api/intune-reporting-devicemanagementreports-get?view=graph-rest-1.0
    Permissions: 
    Delegated (work or school account)	DeviceManagementConfiguration.Read.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementApps.Read.All, DeviceManagementApps.ReadWrite.All, DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All
    Application	DeviceManagementConfiguration.Read.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementApps.Read.All, DeviceManagementApps.ReadWrite.All, DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All
     
.EXAMPLE
    C:\PS> Reporting.ps1
    
.NOTES
    Edited by : Dirk
    Date    : 12.11.2021
    Version    : 1.1
#>

# Variables # 
$TenantID = "" # Replace this attribute with the Azure AD tenant ID
$ClientId = "" # Replace this variable wiht the Azure AD Application Registration ID
$ClientSecret = "" # Replace this variable with the secret

$reportName = "Devices" # Change reportName to any parameter from here - https://docs.microsoft.com/en-us/mem/intune/fundamentals/reports-export-graph-available-reports

# Application authentication # 

$connectionDetails = @{
    'TenantId' = "$TenantID" 
    'ClientId' = "$ClientId" 
    'ClientSecret' = "$ClientSecret" | ConvertTo-SecureString -AsPlainText -Force 
}

$authResult = Get-MsalToken @connectionDetails

$headers1b = @{
'Content-Type'='application/json'
'Authorization'="Bearer " + $authResult.AccessToken
'ExpiresOn'=$authResult.ExpiresOn
}

# Json body # 

$BodyJsonTeam = @"
        {
               "@odata.context": "https://graph.microsoft.com/beta/$metadata#deviceManagement/reports/exportJobs/$entity",
                "id": "",
                "reportName": "$reportName",
                "filter": "",
                "select": [],
                "format": "csv",
                "snapshotId": null,
                "localizationType": "localizedValuesAsAdditionalColumn",
                "status": "notStarted",
                "url": null,
                "requestDateTime": "2021-11-12T16:32:37.671495Z",
                "expirationDateTime": "0001-01-01T00:00:00Z"
        }
"@

# Get reportName ID using json data # 

Write-Host -NoNewline 'Starting the export job request...'
$url = "https://graph.microsoft.com/beta/deviceManagement/reports/exportJobs"
$exportJob = Invoke-RestMethod -Uri $url -body $BodyJsonTeam -Headers $headers1b -Method post -UseBasicParsing -ContentType "application/json"
Write-Host 'Completed'

# Use reportName ID to generate a download URL and pass it through, sleep for URL to generate # 

Write-Host -NoNewline 'Checking status of export'
do {
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/exportJobs('$($exportJob.id)')"
    $exportJob = Invoke-RestMethod -Uri $url -Headers $headers1b -Method get

Start-Sleep -s 10
Write-Host -NoNewline '.'
} while ($exportJob.status -eq 'inProgress')
Write-Host 'Completed export job request'

# Confirm if job has been completed and URL has been generated # 

if ($exportJob.status -eq 'Completed') {
$outfile = (Split-Path -Path $exportJob.url -Leaf).split('?')[0]

# Export to .zip file from the directory script was executed from # 

Write-Host "Export job complete. Writing file $Outfile to disk..."
Invoke-WebRequest -Uri $exportJob.url -Method GET -OutFile $Outfile
Write-Host 'Jobs Done' -ForegroundColor Green
}
