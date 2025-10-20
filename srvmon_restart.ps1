# Force colorful output
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

Write-Host "=== SERVICE MONITOR STARTING ===" -ForegroundColor Cyan

# Define the services to monitor
$ServicesToMonitor = @(
    "NTDS",   # Active Directory Domain Service
    "ADWS",   # Active Directory Web Services
    "AppXsvc" # AppX Deployment Service
)

foreach ($ServiceName in $ServicesToMonitor) {
    Write-Host "Checking: $ServiceName" -ForegroundColor White
    
    try {
        $Service = Get-Service -Name $ServiceName -ErrorAction Stop

        if ($Service.Status -ne "Running") {
            Write-Host "  → '$ServiceName' STOPPED! Starting..." -ForegroundColor Yellow
            Start-Service -InputObject $Service -ErrorAction Stop
            $Service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running, (New-TimeSpan -Seconds 30))

            if ($Service.Status -eq 'Running') {
                Write-Host "  → '$ServiceName' STARTED ✓" -ForegroundColor Green
            } else {
                Write-Host "  → '$ServiceName' FAILED X" -ForegroundColor Red
            }
        } else {
            Write-Host "  → '$ServiceName' RUNNING ✓" -ForegroundColor Green
        }
    } catch {
        Write-Host "  → ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""  # Empty line
}

Write-Host "=== ALL SERVICES CHECKED ===" -ForegroundColor Cyan

# SAVE TO FILE TOO
$logPath = "C:\ServiceCheck_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Get-History | Select-Object -Last 20 | Out-File $logPath
Write-Host "Log saved: $logPath" -ForegroundColor Magenta
