$installScriptDir = ([array](dir $env:ChocolateyInstall\lib\WindowsLiveInstaller.*))[-1]
.$installScriptDir\tools\WindowsLiveInstall.ps1 "Windows Live Mesh" "wlsync"