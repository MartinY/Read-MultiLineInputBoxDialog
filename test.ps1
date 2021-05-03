Clear-Host

Import-Module .\Read-MultiLineInputBoxDialog.ps1

$users = Read-MultiLineInputBoxDialog -WindowTitle "Input some users:" -Message "Users box"

$users
