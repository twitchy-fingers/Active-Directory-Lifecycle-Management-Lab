New-SmbShare -Name "Sales" -Path "C:\Shares\Sales" -FullAccess "Everyone"
Grant-SmbShareAccess -Name "Sales" -AccountName "danotech\SG-FileShare-Sales-RO" -AccessRight Change -Force