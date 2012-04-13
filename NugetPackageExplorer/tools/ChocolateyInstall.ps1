try {
    $drop = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $exe = "$drop\NugetPackageExplorer.exe"
    Install-ChocolateyZipPackage 'NugetPackageExplorer' 'https://github.com/mwrock/Chocolatey-Packages/raw/master/NugetPackageExplorer/NpeLocalExecutable.zip' $drop
    Install-ChocolateyDesktopLink $exe
    $testType = (cmd /c assoc ".nupkg")
    if($testType -ne $null) {
        $fileType=$testType.Split("=")[1]
    } 
    else {
        $fileType="Nuget.Package"
        Start-ChocolateyProcessAsAdmin "cmd /c assoc .nupkg=$fileType"
    }
    Start-ChocolateyProcessAsAdmin "cmd /c ftype $fileType=`"$exe`" %1"
    Write-ChocolateySuccess 'NuGet Package Explorer'
} catch {
    Write-ChocolateyFailure 'NuGet Package Explorer' $($_.Exception.Message)
    throw 
}