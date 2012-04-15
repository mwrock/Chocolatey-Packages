Install-ChocolateyPowershellCommand 'windowsLiveInstall' (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'WindowsLiveInstall.ps1')
