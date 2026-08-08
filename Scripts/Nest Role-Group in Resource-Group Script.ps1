# Nest Finance role group into the Finance file share resource group
Add-ADGroupMember -Identity "SG-FileShare-Finance-RW" -Members "SG-Finance-Users"

# Nest Sales role group into the Sales file share resource group (read-only)
Add-ADGroupMember -Identity "SG-FileShare-Sales-RO" -Members "SG-Sales-Users"

# Nest HR role group into HR resource group
Add-ADGroupMember -Identity "SG-FileShare-HR-RW" -Members "SG-HR-Users"

# All employees get VPN access regardless of department — nest every role group
Add-ADGroupMember -Identity "SG-VPN-Access" -Members "SG-Sales-Users", "SG-Engineering-Users", "SG-Finance-Users", "SG-HR-Users", "SG-IT-Admins"