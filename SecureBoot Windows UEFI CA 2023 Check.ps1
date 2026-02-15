# Intune Remediation - Detection Script
# Checks if Windows UEFI CA 2023 is present in Secure Boot DB
# Exit 0 = Compliant (certificate found)
# Exit 1 = Non-compliant (certificate not found)
 
try {
    $dbDefault = Get-SecureBootUEFI dbDefault -ErrorAction Stop
    $dbContent = [System.Text.Encoding]::ASCII.GetString($dbDefault.bytes)
 
    if ($dbContent -match 'Windows UEFI CA 2023') {
        Write-Output "Compliant: Windows UEFI CA 2023 found in Secure Boot DB"
        exit 0
    }
    else {
        Write-Output "Non-Compliant: Windows UEFI CA 2023 not found in Secure Boot DB"
        exit 1
    }
}
catch {
    Write-Output "Non-Compliant: Unable to read Secure Boot UEFI variables - $($_.Exception.Message)"
    exit 1
}