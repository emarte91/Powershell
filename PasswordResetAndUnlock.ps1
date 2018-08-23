Write-Host "Password Reset and Unlock Tool`n" -ForegroundColor Yellow

$User = Read-Host "Enter in a Username"
    try{
        Get-ADuser $User -properties * | select Name,LockedOut,Enabled,@{n='Password Last Reset';e={$_.PasswordLastSet}},@{n="Job Title";e={$_."Description"}},@{n='Email';e={$_."EmailAddress"}},TelephoneNumber,Office | fl
        $Name = (Get-ADUser $User -Properties Name).name
        }
    catch{
        Write-Warning "$User is incorrect or does not exist.`nTry again"
        \\FileOfYourScript.ps1
        }

    try{
        $Manager = (get-aduser (get-aduser $User -Properties manager).manager).samaccountname
        Get-ADUser $Manager -Properties * | Select @{n="Managers Name";e={$_."Name"}},@{n='Managers Email';e={$_."EmailAddress"}},@{n='Managers Number';e={$_."TelephoneNumber"}} | fl
        }
    catch{
        Write-Host "Manager info not set in AD" -ForegroundColor Yellow
        }


$Correct = Read-Host "Is this the correct user? Y or N"
if ($Correct -eq 'y') {
    if (((get-aduser $user -Properties LockedOut).LockedOut -eq $true) -or ((get-aduser $user -Properties Enabled).Enabled -eq $false)){
        Write-Warning "Account for $Name appears to be locked"
        $Lockout = Read-Host "Would you like to unlock $Name ? Y or N"
            if ($Lockout -eq 'Y'){
                try{
                    Enable-ADAccount $User
                    Unlock-ADAccount $User
                    Write-Host "Sucessfully unlocked account for $Name" -ForegroundColor Green
                }
                catch{
                    Write-Warning "Unable to unlock account for $Name, Try again"
                    \\FileOfYourScript.ps1
                }
            }
            else{
                Write-Warning "Account unlock not selected"
            }
        }
    else{
        Write-Host "$Name's Account is not locked or disabled" -ForegroundColor Green
    }


    $Reset = Read-Host "Would you like to reset $Name's password? Y or N"
    if ($Reset -eq 'Y'){
        Write-Warning "Make sure to verify last 4 #s of Social"
        $Match = Read-Host "Do the last 4 digits of the Social match?"
        if ($Match -eq 'y'){
            try{
                $Password = ConvertTo-SecureString -AsPlainText "Password1" -Force ##Temp Password
                Write-Output "Resetting Password to Password1"
                Set-ADAccountPassword $User -NewPassword $Password -Reset #Sets new password
                Set-ADUser $User -ChangePasswordAtLogon $true #Makes user reset password at logon
                Write-Host "Password has been reset. $Name must change password at next login`n" -ForegroundColor Green
            }
            catch{
                Write-Warning "Unable to reset password maybe due to a permission issue`nReopening script..."
                Start-Sleep -Seconds 1
            }
        }
        else{
            Write-warning "Password not reset"
        }

    }

    else{
        Write-Warning "Password not reset"
     }

    \\FileOfYourScript.ps1
}

else{
    Write-Host "Reopening script..."
    \\FileOfYourScript.ps1
}
