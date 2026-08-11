# Disable-Leaver.ps1
# Fully deprovisions a departing user: strips group memberships, disables the account,
# moves it to a Disabled Users OU, and randomizes the password.
# Run as Administrator on a machine with the ActiveDirectory module.

Import-Module ActiveDirectory

function Disable-Leaver {
    param($Username)

    $user = Get-ADUser $Username -Properties MemberOf

    # Remove all group memberships except Domain Users (Domain Users is the account's
    # primary group and can't be removed this way - it's excluded automatically since
    # it doesn't appear in MemberOf)
    foreach ($group in $user.MemberOf) {
        Remove-ADGroupMember -Identity $group -Members $Username -Confirm:$false
    }

    # Disable account
    Disable-ADAccount -Identity $Username

    # Move to Disabled Users OU
    Move-ADObject -Identity $user.DistinguishedName `
        -TargetPath "OU=Disabled Users,DC=danotech,DC=local"

    # Reset password to random value (in case account is ever reactivated by mistake)
    Set-ADAccountPassword -Identity $Username -Reset `
        -NewPassword (ConvertTo-SecureString ([guid]::NewGuid().ToString()) -AsPlainText -Force)

    Write-Output "$Username fully deprovisioned on $(Get-Date)"
}

Disable-Leaver -Username "sthan"
