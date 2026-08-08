# SG-Resource-Group_Script.ps1
# Creates domain local security groups for resource access (file shares, VPN, etc.)
# Run as Administrator on a machine with the ActiveDirectory module

Import-Module ActiveDirectory

$resourceGroups = @(
    @{Name="SG-FileShare-Finance-RW"; Desc="Read/write access to Finance file share"},
    @{Name="SG-FileShare-Sales-RO";   Desc="Read-only access to Sales file share"},
    @{Name="SG-FileShare-HR-RW";      Desc="Read/write access to HR file share"},
    @{Name="SG-VPN-Access";           Desc="Permission to connect via VPN"}
)

$resourceOU = "OU=Resource-Groups,OU=Groups,DC=danotech,DC=local"

foreach ($grp in $resourceGroups) {
    if (Get-ADGroup -Filter "Name -eq '$($grp.Name)'" -ErrorAction SilentlyContinue) {
        Write-Host "Group already exists, skipping: $($grp.Name)" -ForegroundColor Yellow
        continue
    }

    try {
        New-ADGroup -Name $grp.Name `
            -GroupScope DomainLocal `
            -GroupCategory Security `
            -Path $resourceOU `
            -Description $grp.Desc

        Write-Host "Created group: $($grp.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to create $($grp.Name): $_" -ForegroundColor Red
    }
}
