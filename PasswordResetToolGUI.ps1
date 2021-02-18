Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Function MakeNewForm {
    $PWTool.Close()
    $PWTool.Dispose()
    MakeForm
}

Function Search {
    try {
        $Username = $TextBox.Text
        Get-ADUser $TextBox.Text

        $Name = New-Object System.Windows.Forms.Label
        $Name.Text = "Name: " + (Get-ADUser $Username -Properties Name).name
        $Name.BackColor = "#ffffff"
        $Name.AutoSize = $true
        $Name.Width = 25
        $Name.Height = 10
        $Name.Location = New-Object System.Drawing.Point(20,80)
        $PWTool.Controls.Add($Name)

        $Enabled = New-Object System.Windows.Forms.Label
        $Enabled.Text = "Enabled: " + (Get-ADUser $Username -Properties Enabled).Enabled
        $Enabled.BackColor = "#ffffff"
        $Enabled.AutoSize = $true
        $Enabled.Width = 25
        $Enabled.Height = 10
        $Enabled.Location = New-Object System.Drawing.Point(20,100)
        $PWTool.Controls.Add($Enabled)

        $Locked = New-Object System.Windows.Forms.Label
        $Locked.Text = "Locked Out: " + (Get-ADUser $Username -Properties LockedOut).LockedOut
        $Locked.BackColor = "#ffffff"
        $Locked.AutoSize = $true
        $Locked.Width = 25
        $Locked.Height = 10
        $Locked.Location = New-Object System.Drawing.Point(20,120)
        $PWTool.Controls.Add($Locked)

        $PLS = New-Object System.Windows.Forms.Label
        $PLS.Text = "Password Last Reset: " + (Get-ADUser $Username -Properties PasswordLastSet).PasswordLastSet
        $PLS.BackColor = "#ffffff"
        $PLS.AutoSize = $true
        $PLS.Width = 25
        $PLS.Height = 10
        $PLS.Location = New-Object System.Drawing.Point(20,140)
        $PWTool.Controls.Add($PLS)

        $ResetButton = New-Object System.Windows.Forms.Button
        $ResetButton.Location = New-Object System.Drawing.Size(20,250)
        $ResetButton.Size = New-Object System.Drawing.Size(70,70)
        $ResetButton.Text = "Reset Password"
        $ResetButton.Add_Click({Reset})
        $PWTool.Controls.Add($ResetButton)

        $UnlockButton = New-Object System.Windows.Forms.Button
        $UnlockButton.Location = New-Object System.Drawing.Size(100,250)
        $UnlockButton.Size = New-Object System.Drawing.Size(70,70)
        $UnlockButton.Text = "Unlock Account"
        $UnlockButton.Add_Click({Unlock})
        $PWTool.Controls.Add($UnlockButton)
        
    }

    catch {
        $NotFoundLabel = New-Object System.Windows.Forms.Label
        $NotFoundLabel.Text = "Username $Username not found, clear form"
        $NotFoundLabel.BackColor = "#ffffff"
        $NotFoundLabel.AutoSize = $true
        $NotFoundLabel.Width = 25
        $NotFoundLabel.Height = 10
        $NotFoundLabel.Location = New-Object System.Drawing.Point(100,80)
        $PWTool.Controls.Add($NotFoundLabel)
        
    }
}

Function MakeForm {
    $PWTool = New-Object System.Windows.Forms.Form
    $PWTool.ClientSize = '400,400'
    $PWTool.Text = "Password Reset Tool"
    $PWTool.BackColor = "#ffffff"
    $PWTool.TopMost = $false
    $PWTool.MaximizeBox = $false
    $PWTool.StartPosition = "CenterScreen"

    $Label1 = New-Object System.Windows.Forms.Label
    $Label1.Text = "Enter a username:"
    $Label1.BackColor = "#ffffff"
    $Label1.AutoSize = $true
    $Label1.Width = 25
    $Label1.Height = 10
    $Label1.Location = New-Object System.Drawing.Point(20,34)
    $Label1.Font = "Microsoft Sans Serif,10"
    $PWTool.Controls.Add($Label1)

    $TextBox = New-Object System.Windows.Forms.TextBox
    $TextBox.Multiline = $false
    $TextBox.Width = 100
    $TextBox.Height = 20
    $TextBox.Location = New-Object System.Drawing.Point(138,30)
    $TextBox.Font = "Micorsoft Sans Serif,10"
    $PWTool.Controls.Add($TextBox)

    $Search = New-Object System.Windows.Forms.Button
    $Search.Location = New-Object System.Drawing.Size(250,29)
    $Search.Size = New-Object System.Drawing.Size(60,25)
    $Search.Text = "Search"
    $PWTool.AcceptButton = $Search
    $Search.Add_Click({Search})
    $PWTool.Controls.Add($Search)

    $Clear = New-Object System.Windows.Forms.Button
    $Clear.Location = New-Object System.Drawing.Size(315,29)
    $Clear.Size = New-Object System.Drawing.Size(60,25)
    $Clear.Text = "Clear"
    $Clear.Add_Click({MakeNewForm})
    $PWTool.Controls.Add($Clear)

    [void]$PWTool.ShowDialog()
}

Function Unlock {
            try {
                Unlock-ADAccount $TextBox.Text       
                $UnlockStatus = New-Object System.Windows.Forms.Label
                $UnlockStatus.Text = $TextBox.Text + " account has been unlocked"
                $UnlockStatus.BackColor = "#ffffff"
                $UnlockStatus.AutoSize = $true
                $UnlockStatus.Width = 25
                $UnlockStatus.Height = 10
                $UnlockStatus.ForeColor = "Green"
                $UnlockStatus.Location = New-Object System.Drawing.Point(20,160)
                $PWTool.Controls.Add($UnlockStatus)
            }

            catch {
                $UnlockStatus = New-Object System.Windows.Forms.Label
                $UnlockStatus.Text = "Unable to unlock the account"
                $UnlockStatus.BackColor = "#ffffff"
                $UnlockStatus.AutoSize = $true
                $UnlockStatus.Width = 25
                $UnlockStatus.Height = 10
                $UnlockStatus.ForeColor = "Red"
                $UnlockStatus.Location = New-Object System.Drawing.Point(20,160)
                $PWTool.Controls.Add($UnlockStatus)
            }

        }

Function Reset {
            try {
                $Password = ConvertTo-SecureString -AsPlainText "Password1" -Force #Feel free to change password
                Set-ADAccountPassword $TextBox.Text -NewPassword $Password
                Set-ADUser $TextBox.Text -ChangePasswordAtLogon $true
                $ResetStatus = New-Object System.Windows.Forms.Label
                $ResetStatus.Text = $TextBox.Text + " account password has been reset"
                $ResetStatus.BackColor = "#ffffff"
                $ResetStatus.AutoSize = $true
                $ResetStatus.Width = 25
                $ResetStatus.Height = 10
                $ResetStatus.ForeColor = "Green"
                $ResetStatus.Location = New-Object System.Drawing.Point(20,180)
                $PWTool.Controls.Add($ResetStatus)
                }
            catch {
                $ResetStatus = New-Object System.Windows.Forms.Label
                $ResetStatus.Text = "Unable to reset password"
                $ResetStatus.BackColor = "#ffffff"
                $ResetStatus.AutoSize = $true
                $ResetStatus.Width = 25
                $ResetStatus.Height = 10
                $ResetStatus.ForeColor = "Red"
                $ResetStatus.Location = New-Object System.Drawing.Point(20,180)
                $PWTool.Controls.Add($ResetStatus)
            }


        }

MakeForm
