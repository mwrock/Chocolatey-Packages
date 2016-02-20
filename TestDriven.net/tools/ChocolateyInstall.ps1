try {
    $drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $exe = "$drop\Setup.exe"
    Install-ChocolateyZipPackage 'TestDriven' 'http://www.testdriven.net/downloads/TestDriven.NET-3.9.2905_Personal_RTM.zip' $drop
    Install-ChocolateyInstallPackage "TestDriven" 'exe' "/q" $exe

    Write-ChocolateySuccess 'TestDriven.Net'
} catch {
    Write-ChocolateyFailure 'TestDriven.Net' $($_.Exception.Message)
    throw 
}