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
$dirpath = "C:\temp\O365-demo";
$ImportFile = Import-csv "$dirpath\users.csv"

#Get All Sites collections
$Sites = Get-SPOSite
Foreach ($Site in $Sites)
{
    $ImportFile | foreach {
        Set-SPOUser -site $Site.url -LoginName $_.UserPrincipalName -IsSiteCollectionAdmin $True
    }
} 

