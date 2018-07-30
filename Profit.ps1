#Script to find possibly useful documents. The purpose of this is simple and the implementation is even easier, it's primarily to save time. Results are not written to disk since they are just queried. Should be relatively easy to store the results in variables if needed.
#Written by Z3R0th

Write-Host "Checking filesystem for interesting files...this could take a while..."

$Drives = [System.IO.DriveInfo]::GetDrives() | select-string ":" #Finds all drives on system

$Mutate = [string]$Drives #Convert $Drives into a string.

$FinalForm = $Mutate -split " " #Change the $Mutate variable to separate by blank spaces so that there are individual lines for drive letters.

$drivelist = $FinalForm.replace("\", "\users\") #Piece everything together and add \users\ to the drive letters so that it will only search user folders on target machine.

$Repair = $FinalForm.replace("\", "\Windows\Repair\")

$Hosts = $FinalForm.replace("\", "\Windows\system32\drivers\etc\")

GCI -Recurse -Path $Drives -Filter "*password*" -File -ErrorAction SilentlyContinue | where {($_.Extension -eq ".txt") -or ($_.Extension -eq ".csv") -or ($_.Extension -eq ".db") -or ($_.Extension -eq ".dbf") -or ($_.Extension -eq ".log") -or ($_.Extension -eq ".mdb") -or ($_.Extension -eq ".sav") -or ($_.Extension -eq ".sql") -or ($_.Extension -eq ".tar") -or ($_.Extension -eq ".xml") -or ($_.Extension -eq ".bak") -or ($_.Extension -eq ".pdf") -or ($_.Extension -eq ".tex") -or ($_.Extension -eq ".docx") -or ($_.Extension -eq ".doc") -or ($_.Extension -eq ".xls") -or ($_.Extension -eq ".xlsx")} #Will look for password files.

GCI -Recurse -Path $Drives -Filter "*NTUSER*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".dat"} #Will look for NTUSER.dat files but will only find them if running from admin prompt

GCI -Recurse -Path $Drives -Filter "*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".kbdx"} #Will look for Keepass files.

GCI -Recurse -Path $Drives -Filter "*system*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".bak"} #Will look for backup system file.

GCI -Recurse -Path $Drives -Filter "*security*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".bak"} #Will look for backup security file.

GCI -Recurse -Path $Drives -Filter "*sam*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".bak"} #Will look for backup sam file.

GCI -Recurse -Path $Repair -Filter "*SAM*" -File -ErrorAction SilentlyContinue #Will look for SAM file that exists in Repair.

GCI -Recurse -Path $Repair -Filter "*system*" -File -ErrorAction SilentlyContinue #Will look for system file that exists in Repair.

GCI -Recurse -Path $Repair -Filter "*software*" -File -ErrorAction SilentlyContinue #Will look for software file that exists in Repair.

GCI -Recurse -Path $Repair -Filter "*security*" -File -ErrorAction SilentlyContinue #Will look for security file that exists in Repair.

GCI -Recurse -Path $Hosts -Filter "hosts*" -File -Erroraction SilentlyContinue #Will look for hosts file.

GCI -Recurse -Path $Drives -Filter "*unattend*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".xml"} #Will look for answer files. Sometimes plain-text passwords are stored here.

GCI -Recurse -Path $Drives -Filter "*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".settingcontent-ms"} #Will look for Windows Settings shortcut files. Can be weaponized for code execution.

GCI -Recurse -Path $drivelist -Filter "*" -File -ErrorAction SilentlyContinue | where {$_.Extension -eq ".bat"} #Will look for batch files. Can possibly be edited for code execution. Though this only checks within the user files as there are too many within the filesystem.

Write-Host " "
Write-Host "---------------------------------------------------"
Write-Host "`nFinished. PowerShell 'Modes' are as follows:

d - Directory

a - Archive

r - Read-Only

h - Hidden

s - System

l - Reparse point, symlink, etc.

Example (d-r---) <-- Directory that is read only
"
Write-Host "---------------------------------------------------"
