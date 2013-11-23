try {
    $drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    Install-ChocolateyZipPackage 'InputDirector' 'http://www.inputdirector.com/downloads/InputDirector.v1.3.zip' $drop
    ."$drop/InputDirector.v1.3.build101.Setup.exe" /S
    Write-ChocolateySuccess 'InputDirector'
} catch {
    Write-ChocolateyFailure 'InputDirector' $($_.Exception.Message)
    throw 
}