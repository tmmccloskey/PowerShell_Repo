# System Information
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$cpu = Get-CimInstance -ClassName Win32_Processor
$memory = Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, Size, FreeSpace
$network = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True"
$uptime = $os.LastBootUpTime
$lastBootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$uptimeSpan = (Get-Date) - $lastBootTime
#$uptimeSpan = (Get-Date) - ([System.Management.ManagementDateTimeConverter]::ToDateTime($uptime))
# Display System Information
Write-Host "Operating System: $($os.Caption)"
Write-Host "Version: $($os.Version)"
Write-Host "Manufacturer: $($os.Manufacturer)"
Write-Host "CPU: $($cpu.Name)"
Write-Host "Cores: $($cpu.NumberOfCores)"
