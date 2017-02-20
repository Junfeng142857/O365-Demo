#Set up admin account for the task.
Write-Host "Setting up global admin account..."
$GlobalAdminUser = "tom@yourdomain.onmicrosoft.com"; 
$Password = ConvertTo-SecureString -String "SomePassword" -AsPlainText -Force;
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $GlobalAdminUser, $Password;

#Connect to Microsoft Online (Office 365).
Write-Host "Connecting to Microsoft Online Services..."
Import-Module MsOnline
Connect-MsolService -Credential $Credential; 

#Connect to SharePoint online.
Write-Host "Connecting to SharePoint Online..."
$SPAdminCenterUrl = "https://yourdomain-admin.sharepoint.com";
Connect-SPOService -url $SPAdminCenterUrl -Credential $Credential

#Decalre parameters
Write-Host "Declaring parameters..."
$dirpath = "C:\Temp\O365-demo";
$ImportFile = Import-csv "$dirpath\SPOSites.csv"
$TotalImports = $importFile.Count
#$UserPassword = ConvertTo-SecureString -AsPlainText -String "SomePassword" -Force;

#Create Team Sites
Write-Host "Creating Team Sites"
$counter = 0; 
$ImportFile | foreach {
	$counter++;
	$progress = [int]($counter / $totalImports * 100)
	Write-Progress -Activity "Provisioning Demo Sites" -status "Provisioning sites $counter of $TotalImports" -perc $progress;
    Write-Host "Creating Site $($_.Title)";
	New-SPOSite -Url $_.Url -Owner $_.Owner -StorageQuota $_.StorageQuota -NoWait -ResourceQuota $_.ResourceQuota -Template $_.Template -Title $_.Title
}
