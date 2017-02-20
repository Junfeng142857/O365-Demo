
#Set up admin account for the task.
Write-Host "Setting up global admin account..."
$GlobalAdminUser = "tom@yourdomain.onmicrosoft.com"; 
$Password = ConvertTo-SecureString –String "SomePassword" –AsPlainText -Force;
$Credential = New-Object –TypeName "System.Management.Automation.PSCredential" –ArgumentList $GlobalAdminUser, $Password;

#Connect to Microsoft Online (Office 365).
Write-Host "Connecting to Microsoft Online Services..."
Import-Module MsOnline
Connect-MsolService -Credential $Credential; Connect-MsolService -Credential $credential

#Connect to SharePoint online.
Write-Host "Connecting to SharePoint Online..."
$SPAdminCenterUrl = "https://yourdomain-admin.sharepoint.com";
Connect-SPOService -url $SPAdminCenterUrl -Credential $credential


#Decalre parameters
Write-Host "Declaring parameters..."
$dirpath = "C:\temp\O365-demo";
$Sku = Get-MsolAccountSku;
$LicenseAssignment = $Sku.AccountSkuId; 
$ImportFile = Import-csv "$dirpath\users.csv"
$TotalImports = $importFile.Count
#$UserPassword = ConvertTo-SecureString –AsPlainText -String "SomePassword" -Force;

#Create Users
Write-Host "Creating users"
$counter = 0; 
$ImportFile | foreach {
	$counter++;
	$progress = [int]($counter / $totalImports * 100)
	Write-Progress -Activity "Provisioning User Accounts" -status "Provisioning account $counter of $TotalImports" -perc $progress;
    New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $LicenseAssignment -Password "SomePassword" -PasswordNeverExpires:$true;
}




<#
Set-MsolUserLicense -UserPrincipalName alanb@yourdomain.onmicrosoft.com -AddLicenses $LicenseAssignment
Get-MsolUser
Remove-MsolUser -UserPrincipalName CCole@contoso.com -force
#deleting users
$ImportFile | foreach {
    Remove-MsolUser -UserPrincipalName $_.UserPrincipalName -force
	}
#>
