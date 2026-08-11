$folders = @("C:\Shares\Finance", "C:\Shares\Sales", "C:\Shares\HR")

foreach ($folder in $folders) {
    $acl = Get-Acl $folder
    $permission = "danotech\SG-IT-Admins", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission)
    $acl.AddAccessRule($rule)
    Set-Acl $folder $acl
}