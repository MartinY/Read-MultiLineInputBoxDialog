﻿function Read-MultiLineInputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
{
<#
    .SYNOPSIS
    Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.
     
    .DESCRIPTION
    Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.
     
    .PARAMETER Message
    The message to display to the user explaining what text we are asking them to enter.
     
    .PARAMETER WindowTitle
    The text to display on the prompt window's title.
     
    .PARAMETER DefaultText
    The default text to show in the input box.
     
    .EXAMPLE
    $userText = Read-MultiLineInputBoxDialog "Input some text please:" "Get User's Input"
     
    Shows how to create a simple prompt to get mutli-line input from a user.
     
    .EXAMPLE
    # Setup the default multi-line address to fill the input box with.
    $defaultAddress = @'
    John Doe
    123 St.
    Some Town, SK, Canada
    A1B 2C3
    '@
     
    $address = Read-MultiLineInputBoxDialog "Please enter your full address, including name, street, city, and postal code:" "Get User's Address" $defaultAddress
    if ($address -eq $null)
    {
        Write-Error "You pressed the Cancel button on the multi-line input box."
    }
     
    Prompts the user for their address and stores it in a variable, pre-filling the input box with a default multi-line address.
    If the user pressed the Cancel button an error is written to the console.
     
    .EXAMPLE
    $inputText = Read-MultiLineInputBoxDialog -Message "If you have a really long message you can break it apart`nover two lines with the powershell newline character:" -WindowTitle "Window Title" -DefaultText "Default text for the input box."
     
    Shows how to break the second parameter (Message) up onto two lines using the powershell newline character (`n).
    If you break the message up into more than two lines the extra lines will be hidden behind or show ontop of the TextBox.
     
    .NOTES
    Name: Show-MultiLineInputDialog
    Author: Daniel Schroeder (originally based on the code shown at http://technet.microsoft.com/en-us/library/ff730941.aspx)
    Version: 1.0
#>
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms
     
    # Create the Label.
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Size(10,10) 
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.AutoSize = $true
    $label.Text = $Message
     
    # Create the TextBox used to capture the user's text.
    $textBox = New-Object System.Windows.Forms.TextBox 
    $textBox.Location = New-Object System.Drawing.Size(10,40) 
    $textBox.Size = New-Object System.Drawing.Size(375,200)
    $textBox.AcceptsReturn = $true
    $textBox.AcceptsTab = $false
    $textBox.Multiline = $true
    $textBox.ScrollBars = 'Both'
    $textBox.Text = $DefaultText
     
    # Create the OK button.
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Size(215,250)
    $okButton.Size = New-Object System.Drawing.Size(75,25)
    $okButton.Text = "OK"
    $okButton.Add_Click({ $form.Tag = $textBox.Text; $form.Close() })
     
    # Create the Cancel button.
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Size(310,250)
    $cancelButton.Size = New-Object System.Drawing.Size(75,25)
    $cancelButton.Text = "Cancel"
    $cancelButton.Add_Click({ $form.Tag = $null; $form.Close() })
     
    # Create the File button.
    $fileButton = New-Object System.Windows.Forms.Button
    $fileButton.Location = New-Object System.Drawing.Size(20,250)
    $fileButton.Size = New-Object System.Drawing.Size(75,25)
    $fileButton.Text = "File"
    $fileButton.Add_Click({
	    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	    $OpenFileDialog.ShowDialog() | Out-Null
		if ($OpenFileDialog.filename) { $textBox.Text = (Get-Content $OpenFileDialog.filename) -join "`r`n" }
	})
	 
    # Create the form.
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = $WindowTitle
    $form.Size = New-Object System.Drawing.Size(410,320)
    $form.FormBorderStyle = 'FixedSingle'
    $form.StartPosition = "CenterScreen"
    $form.AutoSizeMode = 'GrowAndShrink'
    $form.Topmost = $True
    $form.AcceptButton = $okButton
    $form.CancelButton = $cancelButton
    $form.ShowInTaskbar = $true
     
    # Add all of the controls to the form.
    $form.Controls.Add($label)
    $form.Controls.Add($textBox)
    $form.Controls.Add($okButton)
    $form.Controls.Add($cancelButton)
	$form.Controls.Add($fileButton)
     
    # Initialize and show the form.
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() > $null   # Trash the text of the button that was clicked.
     
    # Return the text that the user entered.
    return $form.Tag
}
