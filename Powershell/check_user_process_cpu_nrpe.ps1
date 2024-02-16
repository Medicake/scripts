param (
    [string]$user,
    [int]$critical = 100
  )
  $ErrorActionPreference = 'SilentlyContinue'
  if([string]::IsNullOrEmpty($user)) {
    Write-Host "You must supply a user name"
    exit 2
  }
  $cpu_cores = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
  $prod_percentage_cpu_total = 1
  
  (gwmi win32_process | where {$_.getowner().user -eq $user} ) | ForEach-Object {
    $proc_pid =  $_.handle 
    $proc_path = ((Get-Counter "\Process(*)\ID Process").CounterSamples | ? {$_.RawValue -eq $proc_pid}).Path
    $prod_percentage_cpu_total += ((Get-Counter ($proc_path -replace "\\id process$","\% Processor Time")).CounterSamples.CookedValue) / $cpu_cores
  }
  
  $prod_percentage_cpu_total = [Math]::Round($prod_percentage_cpu_total)
  $output = "- Process for user $user is at $($prod_percentage_cpu_total)% |CPU=$($prod_percentage_cpu_total)"
  if ($prod_percentage_cpu_total -ge $critical) {
    Write-Host "CRITICAL $output"
    exit 2
  } else {
    Write-Host "OK $output"
  }
