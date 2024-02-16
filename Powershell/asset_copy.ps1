param (
  [Parameter(Mandatory=$true)]
  [ValidateNotNullOrEmpty()]
  [string]$fromDir,
  [Parameter(Mandatory=$true)]
  [ValidateNotNullOrEmpty()]
  [string]$toDir,
  [Parameter(Mandatory=$true)]
  [ValidateNotNullOrEmpty()]
  [string]$inputFile
)

#Check to see if InputFile Exists
if (-not (Test-path($inputFile))) {
  Write-Host "$inputFile does not exist" -ForegroundColor Red
  exit
}

#Create to directory if it doesn't exist
if (-not (Test-path($toDir))) {
  New-Item -Path $toDir -ItemType "directory"
}

#Read in inputFile
$csv = Import-Csv $inputFile

#hash used to see if files are duplicted
$assets = @{}

#Loop through all rows
foreach ($row in $csv) {

  #See if we have already copied a file with that title
  if (-Not $assets.ContainsKey($row.Title)) {
    #if not add it to the list
    $assets.Add($row.Title, 0)
  } else {
    #if we have increment the counter and apped to title name
    $value = $assets.Get_Item($row.Title).Value + 1
    $assets.Set_Item($row.Title, $value)
    $row.Title = $row.Title -replace "(\.\w+)$","_$($value)$&"
  }

  #Get the extension from the original tile and use for Id
  $null = $row.Title -match "(?<ext>\.\w+)$"
  $ext = $matches['ext']
  
  #Switch the slash so it matches the path directory
  $row.MimeType = $row.MimeType -replace "/", "\"
  
  $fromFile = "$($fromDir)\$($row.MimeType)\$($row.Id)$($ext)"
  $toFile = "$($toDir)\$($row.Title)"
  
  #check to see if fromfile exists
  if (-not (Test-path($fromFile))) {
    Write-Host "$fromFile does not exist" -ForegroundColor Red
  } else {
    #Try to copy the file
    if(Copy-Item $fromFile $toFile -PassThru) {
      Write-Host "Copied `"$($fromFile)`"  to `"$($toFile)`"" -ForegroundColor Green
    } else {
      Write-Host "Faile to copie `"$($fromFile)`" to `"$($toFile)`"" -ForegroundColor Red
    }
  }
  
}

