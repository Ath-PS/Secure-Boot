# Script to analyze Secure Boot CSV - Breakdown by Detection Status and Model
$csvPath = "c:\_PKG\SecureBoot-Examination\DeviceRunStatesByProactiveRemediation_bb2d474e-cd35-4f61-872d-08500253c877.csv"

# Import CSV
$data = Import-Csv -Path $csvPath

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SECURE BOOT ANALYSIS - SUMMARY BY MODEL" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Group by DetectionScriptStatus first
$byStatus = $data | Group-Object -Property DetectionScriptStatus

foreach ($statusGroup in $byStatus) {
    $statusName = $statusGroup.Name
    $statusCount = $statusGroup.Count
    
    Write-Host "`n$statusName" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Yellow
    Write-Host "Total Devices: $statusCount`n" -ForegroundColor White
    
    # Group by Model within this status
    $byModel = $statusGroup.Group | Group-Object -Property Model | Sort-Object -Property Count -Descending
    
    Write-Host "Breakdown by Model:" -ForegroundColor Gray
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    foreach ($modelGroup in $byModel) {
        $modelName = $modelGroup.Name
        $modelCount = $modelGroup.Count
        $percentage = [math]::Round(($modelCount / $statusCount) * 100, 1)
        
        Write-Host "  $modelName`: $modelCount ($percentage%)" -ForegroundColor White
    }
}

# Overall summary
Write-Host "`n`n========================================" -ForegroundColor Green
Write-Host "OVERALL SUMMARY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

$totalDevices = $data.Count
Write-Host "`nTotal Devices in Report: $totalDevices" -ForegroundColor White

foreach ($statusGroup in $byStatus) {
    $statusName = $statusGroup.Name
    $statusCount = $statusGroup.Count
    $percentage = [math]::Round(($statusCount / $totalDevices) * 100, 1)
    
    Write-Host "$statusName`: $statusCount ($percentage%)" -ForegroundColor White
}

Write-Host "" 
