param (
  [string]$server,
  [string]$group
)
if([string]::IsNullOrEmpty($server)) {
  Write-Host "You must supply a server name"
  exit 2
}

if([string]::IsNullOrEmpty($group)) {
  Write-Host "You must supply a group name"
  exit 2
}

$results = Get-ChildItem "SQLSERVER:\SQL\$server\DEFAULT\AvailabilityGroups\$group\AvailabilityReplicas" | Test-SqlAvailabilityReplica | Where-Object { $_.HealthState -ne "Healthy" }
if ($results) {
  $output = "CRITICAL - "
  foreach ($result in $results) {
    $output += $result.Name + " is " +$result.HealthState + "; "
  }
  Write-Host $output
  exit 2
} else {
   Write-Host "Ok - $group Availability is Healthy"
}

