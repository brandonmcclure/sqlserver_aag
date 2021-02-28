#Requires -version 7
param(
    [parameter(Position=0)]$registry 
,[parameter(Position=1)]$repository = "bmcclure89/"
,[parameter(Position=2)][STRING[]]$SQLtagNames = '2019-GDR2-ubuntu-16.04'
,[parameter(Position=3)][securestring]$SAPassword
,[parameter(Position=4)][bool]$isLatest = $true
,[parameter(Position=5)]$workingDir = (Split-Path $PSScriptRoot -parent)
,$ImageName = "sqlserver_adventureworks"
,$TargetImageTag = ":latest"
,$sourceRegistry
,$sourceRepository = 'bmcclure89/'
,$logLevel

)

Import-Module FC_Log, FC_Docker -Force -ErrorAction Stop -DisableNameChecking

if ([string]::IsNullOrEmpty($logLevel)){$logLevel = "Warning"}
Set-LogLevel $logLevel

# Param validation/defaults
foreach($SQLtagName in $SQLtagNames){
	$FQImageName = Get-DockerFQName -Repository $sourceRepository -Registry $sourceRegistry -Image $ImageName -Tag $SQLtagName

    $imageName = "$((Split-Path $workingDir -Leaf).ToLower())"
    Invoke-DockerImageBuild -registry $registry `
    -repository $repository `
    -imageName $imageName `
    -isLatest $isLatest `
    -tagPrefix "$($SQLtagName.tolower())_" `
     -logLevel 'Debug' `
    -workingDir $workingDir
}
    