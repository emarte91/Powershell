Import-Module ActiveDirectory
Import-Csv \\Pathname\ADbulk.csv | ForEach-Object {
    $firstName = $_.firstname
    $lastName = $_.lastname
    $name = $firstName + ' ' + $lastName
    $samAccountName = $firstName[0] + $lastName
    $userPrincipal = $samAccountName + "@companyname.com"
    $ouPath = "OU=Base,OU=Sites,DC=rome,DC=local"
    $password = (ConvertTo-SecureString "Password1" -AsPlainText -Force)
    $enable = $true

    try {
        New-ADUser -Name $name -GivenName $firstName -Surname $lastName -SamAccountName $samAccountName -UserPrincipalName $userPrincipal -Path $ouPath -AccountPassword $password -Enabled $enable -ChangePasswordAtLogon $true
        Write-Host "Successfully created a user account for $name" -ForegroundColor Green
    }
    catch {
        Write-Warning "Something went wrong with $name's account creation"
    }
}
