# Intune Remediation - Detection Script
# Checks if Secure Boot 2023 certificate deployment status is "Updated"
# Exit 0 = Compliant (no remediation needed)
# Exit 1 = Non-compliant (remediation needed)

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"
$RegName = "UEFICA2023Status"

try {
    $RegValue = Get-ItemPropertyValue -Path $RegPath -Name $RegName -ErrorAction Stop

    if ($RegValue -eq "Updated") {
        Write-Output "Compliant: UEFICA2023Status = '$RegValue'"
        exit 0
    }
    else {
        Write-Output "Non-Compliant: UEFICA2023Status = '$RegValue'"
        exit 1
    }
}
catch {
    Write-Output "Non-Compliant: UEFICA2023Status registry value not found"
    exit 1
}