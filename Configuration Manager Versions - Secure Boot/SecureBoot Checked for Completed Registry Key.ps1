# SCCM Configuration Item - Discovery Script
# Checks if Secure Boot 2023 certificate deployment status is "Updated"
# Returns "Compliant" or "Non-Compliant" for CI compliance rule evaluation

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"
$RegName = "UEFICA2023Status"

try {
    $RegValue = Get-ItemPropertyValue -Path $RegPath -Name $RegName -ErrorAction Stop

    if ($RegValue -eq "Updated") {
        return "Compliant"
    }
    else {
        return "Non-Compliant"
    }
}
catch {
    return "Non-Compliant"
}