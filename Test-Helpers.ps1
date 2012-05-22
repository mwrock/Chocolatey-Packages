$packageName = (split-Path (Resolve-Path *.nuspec) -leaf).Replace(".nuspec","")
cpack
$installDir = Join-Path $env:ChocolateyInstall\lib ((split-Path ([array](Resolve-Path *.nupkg))[-1] -leaf).Replace(".nupkg",""))

function CleanUp {
    if(Test-Path $env:Temp\Chocolatey\$packageName) {Remove-Item $env:Temp\Chocolatey\$packageName -Recurse -Force}
    Remove-Item $env:ChocolateyInstall\lib\$packageName* -Recurse -Force
}

function RunInstall {
    cinst $packageName -source (Resolve-Path .) 
}

function Remove-Path($path) {
    $oldEnvVars = $env:Path
    $pathArray = $oldEnvVars -split ";"
    $newEntries = @()
    foreach($entry in $pathArray) { if(!($entry -like "*$path*")) { $newEntries += $entry } }
    $newEnvVars = $newEntries -join ";"
    $env:Path = $newEnvVars
}
<#
$dirBase = (split-Path (Resolve-Path *.nupkg)[-1] -leaf).Replace(".nupkg","")
$packageName = (split-Path (Resolve-Path *.nuspec) -leaf).Replace(".nuspec","")
Remove-Item $env:Temp\Chocolatey\$packageName* -Recurse -Force
Remove-Item $env:ChocolateyInstall\lib\$dirBase* -Recurse -Force
$scriptPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
#Copy-Item $scriptPath\Microsoft.PowerShell_profile.ps1 $profile -Force
cpack
cinst $packageName -source (Resolve-Path .) 
#>