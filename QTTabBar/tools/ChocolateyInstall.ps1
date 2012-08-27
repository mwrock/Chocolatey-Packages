try {
  $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $installerFile = Join-Path $scriptDir 'QTTabBar.au3'

  $tempDir = "$env:TEMP\chocolatey\QTTabBar"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $file = Join-Path $tempDir "QTTabBar.msi"
  Get-ChocolateyWebFile 'QTTabBar' "$file" 'http://downloads.sourceforge.net/project/qttabbar/1.5.0.0%20Beta%202/qttabbar-v1.5.0.0b2.msi'
  
  write-host "Installing `'$file`' with AutoIt3 using `'$installerFile`'"
  $installArgs = "/c autoit3 `"$installerFile`" `"$file`""
  Start-ChocolateyProcessAsAdmin "$installArgs" 'cmd.exe'

  Write-ChocolateySuccess 'QTTabBar'
} catch {
  Write-ChocolateyFailure 'QTTabBar' "$($_.Exception.Message)"
  throw 
}