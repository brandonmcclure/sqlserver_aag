
  Import-Module FC_Core -DisableNameChecking -Force -ErrorAction Stop


$origLocation = Get-Location 
try {
  Set-Location $(Split-Path $PSScriptRoot -Parent)
  $projectRoot = Split-Path $PSScriptRoot -Parent
if (-Not (Test-Path "$projectRoot\AdventureWorksDW2019.bak")) {
  Invoke-WebRequest https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2019.bak -OutFile "$projectRoot\AdventureWorksDW2019.bak"
}
if (-Not (Test-Path "$projectRoot\AdventureWorks2019.bak")) {
  Invoke-WebRequest https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak -OutFile "$projectRoot\AdventureWorks2019.bak"
}
  Invoke-UnixLineEndings -directory ..
}
catch {throw}
finally {
  Set-LOCation $origLocation
}