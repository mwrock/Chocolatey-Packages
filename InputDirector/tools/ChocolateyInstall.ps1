$drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage 'InputDirector' 'https://www.inputdirector.com/downloads/InputDirector.v1.4.zip' $drop
."$drop/InputDirector.v1.4.build110.Setup.exe" /S
