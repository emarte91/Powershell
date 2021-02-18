Write-Host "Main Menu`n`nChoose an option"
$Option = Read-Host "1: Password Reset Script`n2: Exchange Email Creator`n:"

Switch($Option)
{
    1 {"Opening Password script"; \\FilePathHere}
    2 {"Opening Exchange script";\\FilePathHere}
    default {"Incorrect option try again"; \\MainMenu.ps1 }
}
