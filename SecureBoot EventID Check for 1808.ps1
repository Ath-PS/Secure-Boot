# Exit 1 = Complient
# Exit 2 = Non-compliant

# Query the newest 1808 event
$event1808 = Get-WinEvent -FilterHashtable @{
    LogName      = 'System'
    ProviderName = 'Microsoft-Windows-TPM-WMI'
    Id           = 1808
} -MaxEvents 1 -ErrorAction SilentlyContinue

if ($event1808) {
    # Event 1808 found
    Write-Output "Found event 1808"
    exit 0
}
else {
    # No 1808 event found → return the newest event from this provider
    $latestEvent = Get-WinEvent -FilterHashtable @{
        LogName      = 'System'
        ProviderName = 'Microsoft-Windows-TPM-WMI'
    } -MaxEvents 1 -ErrorAction SilentlyContinue

    if ($latestEvent) {
        Write-Output "Newest event: ID $($latestEvent.Id) at $($latestEvent.TimeCreated)"
        exit 1
    }
    else {
        Write-Output "No events found for Microsoft-Windows-TPM-WMI"
        exit 1
    }
}

