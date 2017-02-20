Function Replace-String {
<#
.SYNOPSIS
Replace-String finds a string of text that matches the criteria across multiple files, and replace it with the specified new string.
.DESCRIPTION
This command searches through a directory or the file specified, and obtain the content of the files with Get-Content PowerShell cmdlet, find and replace matching strings within the obtained content and set the new text as the content of the original file. 
.PARAMETER folderPath
Accepts one directory path. If specified, all the files within the folder (not including the subfolders) will be in scope for the text search. 
.PARAMETER file
Accepts the path of one or more files, e.g. "F:\temp\test\profiles.csv"
.PARAMETER oldString
Accepts a string, Regex supported. This specifies the target string to find and to replace.
.PARAMETER newString
Accepts a string. This specifies the new string with which the older strings get replaced.
.EXAMPLE
This example finds all the files within the F:\temp\test folder, replacing strings that matches the pattern "approject" + two digits, and replace them with "project25".
Replace-String -folderPath 'F:\temp\test' -oldString "project\d{2}" -newString 'project25'
.EXAMPLE
This example finds the file "F:\temp\test\profiles.csv" replacing strings that matches the pattern "approject" + two digits, and replace them with "project25".
Replace-String -file 'F:\temp\test\profiles.csv' -oldString "project\d{2}" -newString 'project25'
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$False)]
    [string]
    $folderPath,
    [Parameter(Mandatory=$False)]
    [string[]]
    $file,
    [Parameter(Mandatory=$True)]
    [string]
    $oldString,
    [Parameter(Mandatory=$True)]
    [string]
    $newString
)
#If the user specifies a folder path, find all the files in that folder (not including subfolders), and replace the matching string of text with the new string. 
#The reason why the formats are specified is that this Set-Content cmdlet can mess up with files that are not text based, such as Office Documents and pictures. 
#Only use it with files types that can be edited through Notepad. 
if ($folderPath -ne '') {
    Get-ChildItem  -Path ($folderPath+"\*") -File -Include *.xml,*txt,*.ps1,*.csv | ForEach-Object {
        (Get-Content $PSItem.FullName) -Replace $oldString,$newString | Set-Content -Path $PSItem.FullName;
    }
}
#If a file or multiple files are specified in stead of a foler, only find and replace string within the specified folers. 
elseif ($file -ne '') {
    $file | ForEach-Object {
        (Get-Content $PSItem) -Replace $oldString,$newString | Set-Content -Path $PSItem;
    }
}
elseif (($file -eq '') -AND ($folderPath -eq '') ) {
    Write-Host "Warning: You need to specify what file(s) to process! Specify a file or file path and try again" -ForegroundColor Red;
}
}

# Change your the domain name to your actual domain name. Manually input the folder/file path.
Replace-String -folderPath 'C:temp\test' -oldString "yourdomain" -newString 'companyX'

# Change the common demo environment password to your preference.
Replace-String -folderPath 'C:temp\test' -oldString "SomePassword" -newString 'YourP@ssw0rd'

# Change the global admin account to your account.
Replace-String -folderPath 'C:temp\test' -oldString "tom@yourdomain.onmicrosoft.com" -newString 'you@yourdomain.onmicrosoft.com'