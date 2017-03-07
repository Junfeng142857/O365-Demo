#Set up admin account for the task.
$GlobalAdminUser = "adminuser@yourdomain.onmicrosoft.com"; 
$Password = ConvertTo-SecureString –String "Y0urP@ssw0rd" –AsPlainText -Force;
$Credential = New-Object –TypeName "System.Management.Automation.PSCredential" –ArgumentList $GlobalAdminUser, $Password;


#Connect to Exchange Online for photo updates. Make sure proxymethod is set to "RPS" for photos larger than 10KB.
Write-Host "Connect to Exchange Online for photo updates..."
$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/?proxymethod=rps" -Credential $Credential -Authentication "Basic" -AllowRedirection
Import-PSSession $exchangeSession -DisableNameChecking

#Declare parameters
$dirpath = "F:\test\O365-demo";
$ImportFile = Import-csv "$dirpath\users.csv";
$TotalImports = $importFile.Count;


#Update photos
Write-Host "Updating user photos..."
$counter = 0; 
$ImportFile | foreach {
	$counter++;
	$progress = [int]($counter / $totalImports * 100);
	Write-Progress -Activity "Updating User Photos" -status "Updating user photo $counter of $TotalImports" -perc $progress;
    if (get-childitem "$dirpath\userimages\$($_.DisplayName).jpg"){
	$photo = [System.IO.File]::ReadAllBytes("$dirpath\userImages\$($_.DisplayName).jpg")	
	Set-UserPhoto $_.UserPrincipalName -PictureData $photo -confirm:$false
	}
}

Write-Host "Photo update completed!"
