# SCCM Configuration Item - Discovery Script
# Checks if Event ID 1808 exists from Microsoft-Windows-TPM-WMI provider
# Returns "Compliant" or "Non-Compliant" for CI compliance rule evaluation

# Query the newest 1808 event
$event1808 = Get-WinEvent -FilterHashtable @{
    LogName      = 'System'
    ProviderName = 'Microsoft-Windows-TPM-WMI'
    Id           = 1808
} -MaxEvents 1 -ErrorAction SilentlyContinue

if ($event1808) {
    return "Compliant"
}
else {
    return "Non-Compliant"
}
