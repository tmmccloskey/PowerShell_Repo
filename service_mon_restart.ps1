# Define the services to monitor
$ServicesToMonitor = @(
    "NTDS",   # Active Directory Domain Service
    "ADWS",   # Active Directory Web Services
    "AppXsvc" # AppX Deployment Service

foreach ($ServiceName in $ServicesToMonitor) {
    try {
        $Service = Get-Service -Name $ServiceName -ErrorAction Stop

        # Check if the service is running
        if ($Service.Status -ne "Running") {
            Write-Host "Service '$ServiceName' is not running. Attempting to start..." -ForegroundColor Yellow
            Start-Service -InputObject $Service -ErrorAction Stop

            # Wait up to 30 seconds for the service to start
            $Service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running, (New-TimeSpan -Seconds 30))

            # Verify if the service started successfully
            if ($Service.Status -eq 'Running') {
                Write-Host "Service '$ServiceName' successfully started." -ForegroundColor Green
            } else {
                Write-Host "Failed to start service '$ServiceName'." -ForegroundColor Red
            }
        } else {
            Write-Host "Service '$ServiceName' is already running." -ForegroundColor Green
        }
    } catch {
        Write-Host "Error processing service '$ServiceName': $($_.Exception.Message)" -ForegroundColor Red
    }
}
)s
