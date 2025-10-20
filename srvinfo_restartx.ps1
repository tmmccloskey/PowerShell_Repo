param(
    [string[]]$ServicesToMonitor = @("NTDS", "ADWS", "AppXsvc")
)

# Windows Service Monitor and Restart Script
Write-Host "🚀 Starting Service Check..." -ForegroundColor Cyan

# CONFIGURATION: List the service names to monitor here

foreach ($ServiceName in $ServicesToMonitor) {
    try {
        $Service = Get-Service -Name $ServiceName -ErrorAction Stop
        
        if ($Service.Status -ne "Running") {
            Write-Host "  🔄 STARTING $ServiceName..." -ForegroundColor Yellow
            Start-Service -Name $ServiceName -ErrorAction Stop
            Start-Sleep -Seconds 3
            $Service.Refresh()
            
            if ($Service.Status -eq "Running") {
                Write-Host "  ✅ $ServiceName STARTED!" -ForegroundColor Green
            } else {
                Write-Host "  ❌ $ServiceName FAILED!" -ForegroundColor Red
            }
        } else {
            Write-Host "  ✅ $ServiceName RUNNING" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "  ❌ ERROR $ServiceName : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "🎉 ALL SERVICES CHECKED!" -ForegroundColor Cyan
