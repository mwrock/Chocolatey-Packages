try {
    $drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $exe = "$drop\Setup.exe"
    Install-ChocolateyZipPackage 'TestDriven' 'http://www.testdriven.net/downloads/TestDriven.NET-3.3.2779_Personal_Beta2.zip' $drop
    Install-ChocolateyInstallPackage "TestDriven" 'exe' "/quiet" $exe

    Write-ChocolateySuccess 'TestDriven.Net'
} catch {
    Write-ChocolateyFailure 'TestDriven.Net' $($_.Exception.Message)
    throw 
}