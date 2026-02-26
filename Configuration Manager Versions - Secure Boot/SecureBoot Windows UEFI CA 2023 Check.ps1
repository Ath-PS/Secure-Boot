# SCCM Configuration Item - Discovery Script
# Checks if Windows UEFI CA 2023 is present in Secure Boot DB
# Returns "Compliant" or "Non-Compliant" for CI compliance rule evaluation
 
try {
    $dbDefault = Get-SecureBootUEFI dbDefault -ErrorAction Stop
    $dbContent = [System.Text.Encoding]::ASCII.GetString($dbDefault.bytes)
 
    if ($dbContent -match 'Windows UEFI CA 2023') {
        return "Compliant"
    }
    else {
        return "Non-Compliant"
    }
}
catch {
    return "Non-Compliant"
}