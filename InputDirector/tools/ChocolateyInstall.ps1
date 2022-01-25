$drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage 'InputDirector' 'https://www.inputdirector.com/downloads/InputDirector.v2.1.1.zip' $drop -Checksum 6DBC57220B55B2D053CE9160D5E85170B6E6388CF75D0EF2384957DE4F180B33 -ChecksumType SHA256
."$drop/InputDirector.v2.1.1.build150.Setup.exe" /S
