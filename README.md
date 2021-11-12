# Intune Graph API Reporting

Download the Reporting.ps1 to a your local drive (C:\Temp) and run the script from this location. It will download the output from the same location it's being executed from.

    Export the specified report from Intune to your local storage as a .zip
    Required to create a App Registration with the following permissions to read the data: https://docs.microsoft.com/en-us/graph/api/intune-reporting-devicemanagementreports-get?view=graph-rest-1.0
    
    Permissions: 
    Delegated (work or school account)	DeviceManagementConfiguration.Read.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementApps.Read.All, DeviceManagementApps.ReadWrite.All, DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All
    Application	DeviceManagementConfiguration.Read.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementApps.Read.All, DeviceManagementApps.ReadWrite.All, DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All

Replace the Variables part and run script for output.
