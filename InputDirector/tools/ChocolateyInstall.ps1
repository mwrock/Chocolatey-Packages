$drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage 'InputDirector' 'http://inputdirector.com/downloads/InputDirector.v2.1.zip' $drop -Checksum FA24FD0AC0A7E15BD773E88E2F97D5BFE373181C1672DCD092E667F6AA7BE599 -ChecksumType SHA256
."$drop/InputDirector.v2.1.build146.Setup.exe" /S
