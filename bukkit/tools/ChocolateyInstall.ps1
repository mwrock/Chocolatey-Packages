$packageName = 'bukkit'
$downloadDir="$env:temp\chocolatey\bukkit"
$downloadFile="$downloadDir\craftbukkit.jar"
$installDir = "$env:systemdrive\tools\bukkit"
$url = 'http://dl.bukkit.org/downloads/craftbukkit/get/02389_1.6.4-R2.0/craftbukkit.jar'

try {
  if($env:chocolatey_bin_root -ne $null){
    $installDir = Join-Path $env:chocolatey_bin_root bukkit
  }
  $installFile = Join-Path $installDir "craftbukkit.jar"
  $installBatFile = Join-Path $installDir "bukkit.bat"
  if(!(Test-Path $downloadDir)){mkdir $downloadDir}
  Get-ChocolateyWebFile "bukkit" "$downloadFile" "$url"
  if(Test-Path $installFile){
    Write-host "Deleting previous install"
    Remove-Item $installFile
  }
  if(!(Test-Path $installDir)){mkdir $installDir}
  Copy-Item $downloadFile $installFile
  Write-host "craftbukkit.jar written to $installFile"

  if(!(Test-Path $installBatFile)){
    Copy-Item (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'bukkit.bat') $installBatFile
  }

  write-host "Creating bukkit.bat in chocolatey bin. Bukkit is in your path and will start the bukkit server."
  "@echo off
  ""$installBatFile"" %*" | Out-File "$env:chocolateyinstall\bin\bukkit.bat" -encoding ASCII

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}