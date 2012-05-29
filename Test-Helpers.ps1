$packageName = (split-Path (Resolve-Path *.nuspec) -leaf).Replace(".nuspec","")
cpack
$chocInstallDir = Join-Path $env:ChocolateyInstall\lib ((split-Path ([array](Resolve-Path $packageName*nupkg))[-1] -leaf).Replace(".nupkg",""))

function CleanUp ($package = $packageName){
    Clean-Temp $package
    Remove-Item $env:ChocolateyInstall\lib\$package* -Recurse -Force
    $env:poshHgZip = "c:\dev\Autobox\posh-hg.zip"
}

function Clean-Temp  ($package = $packageName){
    if(Test-Path $env:Temp\Chocolatey\$package) {Remove-Item $env:Temp\Chocolatey\$package -Recurse -Force}
}

function RunInstall {
    cinst $packageName -source (Resolve-Path .) 
}

function Remove-Path($path) {
    $oldEnvVars = $env:Path
    $pathArray = $oldEnvVars -split ";"
    $newEntries = @()
    $ret = $null
    foreach($entry in $pathArray) { if(!($entry -like "*$path*")) { $newEntries += $entry } else {$ret = $entry}} 
    $newEnvVars = $newEntries -join ";"
    $env:Path = $newEnvVars
    return $ret
}
