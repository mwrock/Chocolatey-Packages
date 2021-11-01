$drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage 'InputDirector' 'http://inputdirector.com/downloads/InputDirector.v2.1.zip' $drop
."$drop/InputDirector.v2.1.build146.Setup.exe" /S
