# Move-Employee.ps1
# Transfers an employee between departments: updates group membership,
# moves the AD object to the new OU, and updates the Department attribute.
# Run as Administrator on a machine with the ActiveDirectory module.

Import-Module ActiveDirectory

function Move-Employee {
    param(
        $Username,
        $OldDept,
        $NewDept,
        $OldGroup = "SG-$OldDept-Users",   # override if the old dept's group doesn't follow the standard naming pattern
        $NewGroup = "SG-$NewDept-Users"    # override if the new dept's group doesn't follow the standard naming pattern
    )

    # Remove old department access
    Remove-ADGroupMember -Identity $OldGroup -Members $Username -Confirm:$false

    # Add new department access
    Add-ADGroupMember -Identity $NewGroup -Members $Username

    # Move AD object to new OU
    $user = Get-ADUser $Username
    Move-ADObject -Identity $user.DistinguishedName `
        -TargetPath "OU=$NewDept,OU=Employees,DC=danotech,DC=local"

    Set-ADUser $Username -Department $NewDept

    Write-Output "$Username moved from $OldDept to $NewDept"
}

Move-Employee -Username "kmbappe" -OldDept "Engineering" -NewDept "IT" -NewGroup "SG-IT-Admins"
