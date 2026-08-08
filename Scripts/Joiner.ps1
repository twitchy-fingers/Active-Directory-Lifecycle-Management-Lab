Import-Module ActiveDirectory

$users = Import-Csv "C:\IAM-Lab\NewHires.csv"

foreach ($u in $users) {
    $ouPath = "OU=$($u.Department),OU=Employees,DC=danotech,DC=local"
    $upn = "$($u.SamAccountName)@danotech.local"

    New-ADUser -Name "$($u.FirstName) $($u.LastName)" `
        -GivenName $u.FirstName -Surname $u.LastName `
        -SamAccountName $u.SamAccountName -UserPrincipalName $upn `
        -Path $ouPath -Title $u.Title -Department $u.Department `
        -AccountPassword (ConvertTo-SecureString "Changeme123!" -AsPlainText -Force) `
        -ChangePasswordAtLogon $true -Enabled $true

    Add-ADGroupMember -Identity "SG-$($u.Department)-Users" -Members $u.SamAccountName

    Write-Output "Provisioned $($u.SamAccountName) in $($u.Department)"
}
