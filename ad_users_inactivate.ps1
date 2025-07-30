#List AD with password last set and last logon timestamp more than 120 days
$d = [DateTime]::Today.AddDays(-120)
Get-ADUser -Filter '(PasswordLastSet -lt $d) -or (LastLogonTimestamp -lt $d)' -SearchBase "" -Properties PasswordLastSet,LastLogonTimestamp | ft Name,PasswordLastSet,@{N="LastLogonTimestamp";E={[datetime]::FromFileTime($_.LastLogonTimestamp)}}


#List AD with password last set more than X days
Get-ADUser -Filter '(PasswordLastSet -lt $d)' -SearchBase "" -Properties PasswordLastSet | ft Name,PasswordLastSet

#List AD with last logon more than X days
1. Get-ADUser -Filter '(LastLogonTimestamp -lt $d)' -SearchBase "" -Properties LastLogonTimestamp | ft Name,@{N="LastLogonTimestamp";E={[datetime]::FromFileTime($_.LastLogonTimestamp)}}

#List Inactive AD Users 
2. Search-ADAccount -AccountInactive -TimeSpan ([timespan]120d) -SearchBase ""

#List Inactive AD Users with Filter and Filter the results based on pattern
3. Search-ADAccount -AccountInactive -TimeSpan ([timespan]120d) -SearchBase "" -UsersOnly | where {$_.SamAccountName -notlike '*??*'}

#List Inactive AD Users with Filter and Filter the results based on pattern and disable user adding a description
4. Search-ADAccount -AccountInactive -TimeSpan ([timespan]120d) -SearchBase "" -UsersOnly | where {$_.SamAccountName -notlike '*??*'} | Set-ADUser -Enabled $false -Description "Desabilitado"

#List Inactive AD Users with Filter and Filter the results based on pattern and disable user
$today = [DateTime]::Now
Search-ADAccount -AccountInactive -TimeSpan ([timespan]120d) -SearchBase "" -UsersOnly | where {$_.SamAccountName -notlike '*??*'} | Set-ADUser -Enabled $false -Description "Desabilitado em $($today)"

#List Inactive AD Users with Filter and Filter the results based on pattern and disable user and move user to another OU
$today = Get-Date -Format "dd/MM/yyyy HH:mm"
Search-ADAccount -AccountInactive -TimeSpan ([timespan]120d) -SearchBase "" -UsersOnly | where {$_.SamAccountName -like 'radar.mn*'}  | Set-ADUser -Enabled $false -Description "Desabilitado devido inatividade"
Search-ADAccount -AccountDisable -SearchBase "" | Move-ADObject -TargetPath "OU="



#Script to list and lock account due to X days last logon
$DaysInactive = 120
$time = (Get-Date).AddDays(-($DaysInactive))
$InactiveUsers = Get-ADUser -Filter {LastLogonTimestamp -lt $time -and Enabled -eq $true} -Properties LastLogonTimestamp -SearchBase "" 
|
                 Select-Object Name, SamAccountName, DistinguishedName, @{Name="LastLogonDate";Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
foreach ($user in $InactiveUsers) {
    Write-Host "Disabling $($user.Name)..."
    Set-ADUser -Identity $user.SamAccountName -Enabled $false -Description "Disabled due to inactivity for $($DaysInactive) days."
    Write-Host "Disabled $($user.Name)."
}
