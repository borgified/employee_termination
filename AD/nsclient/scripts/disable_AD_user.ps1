param(
[string]$Email
)

Get-ADUser -filter {EmailAddress -like $Email} | Move-ADObject -TargetPath "OU=TermedUsers,OU=Actian Corporation,DC=Actian,DC=com"
Get-ADUser -filter {EmailAddress -like $Email}
