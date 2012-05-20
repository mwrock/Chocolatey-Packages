$dirBase = (split-Path (Resolve-Path *.nupkg)[-1] -leaf).Replace(".nupkg","")
$packageName = (split-Path (Resolve-Path *.nuspec) -leaf).Replace(".nuspec","")
Remove-Item $env:Temp\Chocolatey\$packageName* -Recurse -Force
Remove-Item $env:ChocolateyInstall\lib\$dirBase* -Recurse -Force
$scriptPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
#Copy-Item $scriptPath\Microsoft.PowerShell_profile.ps1 $profile -Force
cpack
cinst $packageName -source (Resolve-Path .) 